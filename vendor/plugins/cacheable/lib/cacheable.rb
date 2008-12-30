module Cacheable
  def self.included(base) #:nodoc:
    super
    base.extend ClassMethods
    base.extend MethodMissing

    class << base
      include MethodMissing

      cattr_accessor :cache_records
      @@cache_records = false

      alias_method_chain :method_missing, :cached_method
    end
  end

  module MethodMissing #:nodoc:
    def respond_to?(method_id, include_priv = false) #:nodoc:
      super(method_id.to_s.sub(/^cached_/, ''), include_priv)
    end

    def method_missing_with_cached_method(method_id, *arguments, &block)
      unless method_id.to_s.index('cached_') == 0
        # call the original method_missing unless cached_something_or_other
        method_missing_without_cached_method(method_id, *arguments, &block)
      else
        # call cached_method :something_or_other ...
        cached_method(method_id.to_s.sub(/^cached_/, ''), :with => arguments, &block)
      end
    end
  end

  module ClassMethods #:nodoc:
    # Cached Find
    #
    # Usage:
    # User.cached_find(123)
    #   => key store is User/find/123 and returns the result of calling User.find(123)
    #
    # User.cached_find(1,2,3)
    #   => key store is User/find/1/2/3 and returns the result of calling User.find(1,2,3)
    #
    # User.cached_find(:first)
    #   => key store is User/find/first and returns the result of calling User.find(:first)
    #
    # User.cached_find(:last_by_created_at){ |u| u.last(:order => 'created_at') }
    #   => key store is User/find/last_by_created_at and returns the result of calling User.last(:order => 'created_at')
    #
    # User.cached_find(:foo, :all, :conditions => { :display_name => 'foo' })
    #   => key store is User/find/foo and returns the result of calling User.find(:all, :conditions => { :display_name => 'foo' })
    #
    # User.cached_find(:all, :conditions => { :display_name => 'foo' })
    #   => key store is User/find/all/conditions%5Bdisplay_name%5D=foo and returns the result of calling User.find(:all, :conditions => { :display_name => 'foo' })
    #
    # User.cached_find(:random, :first, :conditions => 'rand')
    #   => key store is User/find/random/ and returns the result of calling User.find(:first, :conditions => 'rand')
    #
    def cached_find(*args, &blk)
      # Check for the presence of two hashes and setup cache_options
      cache_options = has_cache_options?(args) ? args.pop : {}

      # If a cache key is given then use it
      key = has_cache_id?(args) ? args.shift : args

      cached_method(:find, :with => args, :key => key, :cache => cache_options, &blk)
    end

    # Convenience method for accessing an Object by id via cached_find
    # Usage:
    #
    # User[123]
    #   => User.cached_find(123)
    #
    def [](n)
      cached_find(n)
    end unless method_defined?(:[])
    # #:nodoc: alias :[] :cached_find unless method_defined?(:[])

    # Cache the results of a class method
    #
    # Usage:
    # Episode.cached_method(:recent)
    #   => key store is Episode/recent and returns the result of calling Episode.recent
    # 
    # Episode.cached_method(:censored){ |e| e.all(:conditions => { :censored => true }) }
    #   => key store is Episode/censored and returns the result of calling Episode.all(:conditions => { :censored => true })
    # 
    # Episode.cached_method(:regexp_for, :with => [:title], :key => 'regexp_for_title')
    #   => key store is Episode/regexp_for_title and returns the result of calling Episode.regexp_for(:title)
    # 
    def cached_method(method_name, options = {}, &blk)
      with, cache_options, key = self.parse_cache_options(options)
      key = cache_id(scope_cache_key(key, method_name))
      Rails.cache.fetch(key, cache_options){ block_given? ? blk.call(self) : self.send(method_name, *with) }
    end

    # Expire cache by args
    def expire_cache(*args)
      Rails.cache.delete(cache_id(*args))
    end

    # paramaterized key, scoped to scope (default to self)
    #
    # usage:
    # Product.scope_cache_key(:sale)
    #   => 'Product/sale'
    #
    # Product.scope_cache_key(:sale, :first)
    #   => 'Product/first/sale'
    #
    def scope_cache_key(key, scope = self)
      ActiveSupport::Cache.expand_cache_key(key, scope)
    end

    # paramaterized key from method arguments, scoped to the class
    #
    # usage:
    # Product.cache_id(:sale, 1,2,3)
    #   => 'Product/sale/1/2/3'
    #
    # Product.cache_id(:find, :first)
    #   => 'Product/find/first'
    #
    def cache_id(*args)
      scope_cache_key(args.compact, self)
    end

    # Parse options for class and instance cached_method
    def parse_cache_options(options = {})
      with = options.delete(:with) || []
      with = [with] unless with.is_a?(Array) # wrap up method arguments in an Array
      cache_options = options.delete(:cache) || {}
      key = options.delete(:key) || with # ''
      [with, cache_options, key]
    end

    protected
      # Used to determine if cached_find is called with cache options
      def has_cache_options?(args)
        args.last(2).all?{ |arg| arg.is_a?(Hash) }
      end

      # Used to determine if cached_find is called with a cache id
      def has_cache_id?(args)
        args.size > 1 && args.first(2).all?{ |arg| [String, Symbol].include?(arg.class) }
      end
  end

  # Cache
  def cached_method(method_name, options = {}, &blk)
    with, cache_options, key = self.class.parse_cache_options(options)
    key = self.class.cache_id(self.class.scope_cache_key([method_name, key], self.id))
    Rails.cache.fetch(key, cache_options){ block_given? ? blk.call(self) : self.send(method_name, *with) }
  end

  # Expire cache for a record
  def expire_record
    self.class.expire_cache(:find, self.id) unless self.new_record?
    self.class.expire_cache(self.id) unless self.new_record?
  end

  # Cache a record by ID
  def cache_record(options = {})
    options = { :force => false }.merge(options)
    key = options.delete(:key) || self.class.cache_id(self.id)
    Rails.cache.fetch(key, options){ self } unless self.new_record?
  end

  # Cache all found records, warning!
  def after_find
    self.cache_record unless self.class.cache_records
  end

  # Reset cache for all records after save, warning!
  def after_save
    self.cache_record(:force => true) unless self.class.cache_records
    self.expire_record
  end
end