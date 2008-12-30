module ActiveSupport
  module Cache
    module Patches
      module DefaultExpiresIn
        def self.included(base)
          super
          base.send(:attr_accessor, :expires_in)
          base.send(:alias_method_chain, :expires_in, :default_value)
        end

        def expires_in_with_default_value(options)
          ((options && options[:expires_in]) || @expires_in).to_i
        end
      end
    end
  end
end
