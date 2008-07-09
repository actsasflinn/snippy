class LanguagesController < ApplicationController
  # GET /languages
  # GET /languages.xml
  def index
    @languages = Language.paginate(:page => params[:page], :order => "snippets_count desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @languages }
      format.json { render :json => @languages, :callback => params[:callback] }
    end
  end
end
