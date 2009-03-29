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
    :is_spam => TyrantObject::boolean,
    :created_at => TyrantObject::time,
    :updated_at => TyrantObject::time
  }
end
