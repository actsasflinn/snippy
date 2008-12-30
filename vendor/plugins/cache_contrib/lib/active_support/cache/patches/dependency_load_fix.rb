# Fix fetch caching when using :load for dependencies (cache_classes = false)
# This fixes cache calls (due to class reloading in dev) by simply calling the fetch block
# Parts taken from http://blog.bashme.org/2008/07/25/rails-21-model-caching-issue/ and
# http://thewebfellas.com/blog/2008/6/9/rails-2-1-now-with-better-integrated-caching#comment-1171
#
module ActiveSupport
  module Cache
    module Patches
      module DependencyLoadFix
        def self.included(base)
          super
          base.alias_method_chain :fetch, :dependency_load_fix
        end

        def fetch_with_dependency_load_fix(*arguments)
          block_given? ? yield : fetch_without_dependency_load_fix(*arguments)
        end
      end
    end
  end
end
