class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :stats

  def stats
    @top_tags = Tag.with_snippets.paginate(:page => 1, :per_page => 10, :order => 'taggings_count desc')
    @top_languages = Language.with_snippets.paginate(:page => 1, :conditions => "snippets_count > 0", :order => 'snippets_count desc')
  end
end
