require 'uri'

class Snippet
  include TyrantObject

  cattr_accessor :tyrant
  @@tyrant = TokyoTyrant::Table.new('127.0.0.1', 1978)

  @@properties = {
    :id => Integer,
    :body => String,
    :author => String,
    :email => String,
    :url => URI,
    :is_spam => proc{ |v|
      return true if v.is_a?(TrueClass)
      return false if v.is_a?(FalseClass)
      v.to_i == 0 ? false : true
    }
  }
end
