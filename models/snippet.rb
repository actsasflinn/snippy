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
    :url => URI
  }
end