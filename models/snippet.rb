class Snippet
  include TyrantObject

  @@properties = {
    :id => Integer,
    :body => String,
    :author => String,
    :email => String,
    :url => String
  }
end