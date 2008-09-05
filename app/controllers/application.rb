# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f420d9d3644bc199e91cbf2962910b70'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  before_filter :stats

  def stats
    @top_tags = Tag.with_snippets.paginate(:page => 1, :order => 'taggings_count desc')
    @top_languages = Language.with_snippets.paginate(:page => 1, :conditions => "snippets_count > 0", :order => 'snippets_count desc')
  end
end
