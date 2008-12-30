require 'memcached'

module ActiveSupport
  module Cache
    class MemcachedStore < Store
      # TODO: Remove these if they ever make it into core
      include ActiveSupport::Cache::Patches::AutoLoadMissingConstants
      include ActiveSupport::Cache::Patches::DefaultExpiresIn

      attr_reader :addresses

      def initialize(*addresses)
        addresses = addresses.flatten
        options = addresses.extract_options!
        addresses = ["localhost"] if addresses.empty?
        @addresses = addresses
        @data = Memcached::Rails.new(addresses, options)
      end

      def read(key, options = nil)
        super
        @data.get(key, raw?(options))
      rescue Memcached::Error => e
        logger.error("Memcached::Error (#{e}): #{e.message}")
        nil
      end

      # Set key = value. Pass :unless_exist => true if you don't 
      # want to update the cache if the key is already set. 
      def write(key, value, options = nil)
        super
        method = options && options[:unless_exist] ? :add : :set
        response = @data.send(method, key, value, expires_in(options), raw?(options))
        response == nil
      rescue Memcached::Error => e
        logger.error("Memcached::Error (#{e}): #{e.message}")
        false
      end

      def delete(key, options = nil)
        super
        response = @data.delete(key)
        response == nil
      rescue Memcached::Error => e
        logger.error("Memcached::Error (#{e}): #{e.message}")
        false
      end

      def exist?(key, options = nil)
        # Doesn't call super, cause exist? in memcache is in fact a read
        # But who cares? Reading is very fast anyway
        !read(key, options).nil?
      end

      def increment(key, amount = 1)       
        log("incrementing", key, amount)

        @data.incr(key, amount)  
      rescue Memcached::Error
        nil
      end

      def decrement(key, amount = 1)
        log("decrement", key, amount)

        @data.decr(key, amount) 
      rescue Memcached::Error
        nil
      end        

      def delete_matched(matcher, options = nil)
        super
        raise "Not supported by Memcache" 
      end        

      def clear
        @data.respond_to?(:flush_all) ? @data.flush_all : @data.flush
      end        

      def stats
        @data.stats
      end

      private
        def expires_in(options)
          (options && options[:expires_in]) || 0
        end

        def raw?(options)
          options && options[:raw]
        end
    end
  end
end
