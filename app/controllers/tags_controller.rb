class TagsController < ApplicationController
  # GET /tags
  # GET /tags.xml
  def index
    @tags = Tag.paginate(:page => params[:page], :order => "taggings_count desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
      format.json { render :json => @tags, :callback => params[:callback] }
    end
  end
end
