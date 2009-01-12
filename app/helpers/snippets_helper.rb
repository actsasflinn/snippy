module Merb
  module SnippetsHelper
    def languages
      Language.all(:order => [:name])
    end
  end
end # Merb