# Copyright (c) 2007 Chris Wanstrath
module ActiveSupport
  module Cache
    module Patches
      module AutoLoadMissingConstants
        def self.included(base)
          super
          base.alias_method_chain :read, :auto_load
        end

        def autoload_missing_constants
          yield
        rescue ArgumentError, MemCache::MemCacheError => error
          lazy_load ||= Hash.new { |hash, hash_key| hash[hash_key] = true; false }
          if error.to_s[/undefined class|referred/] && !lazy_load[error.to_s.split.last.constantize] then retry
          else raise error end
        end

        def read_with_auto_load(*args)
          autoload_missing_constants do
            read_without_auto_load(*args)
          end
        end
      end
    end
  end
end