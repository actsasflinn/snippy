# Fixes for memcache
require 'memcache/make_cache_key_with_underscore'
require 'memcache/timeout'

# Add a default expires_in value for cache stores that use it
require 'active_support/cache/patches/expires_in_default'

# Fix to autoload missing classes with unmarshaling
require 'active_support/cache/patches/read_with_autoload'

# Fix for fetch when cache_classes is false
require 'active_support/cache/patches/dependency_load_fix'

module ActiveSupport::Cache
  # Make :memcached_store available for use
  autoload :MemcachedStore, 'active_support/cache/memcached_store'

  class Store
    # Add to base even though non-memcached formats don't support it,
    # it's an ugly workaround for the fact that plugins are loaded after initialize_cache
    attr_writer :expires_in

    include DependencyLoadFix if ActiveSupport::Dependencies.mechanism == :load
  end

  class MemCacheStore < Store
    include AutoLoadMissingConstants
    include DefaultExpiresIn
  end

  class MemcachedStore < Store
    include AutoLoadMissingConstants
    include DefaultExpiresIn
  end
end
