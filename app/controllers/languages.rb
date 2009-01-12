class Languages < Application
  provides :xml, :js

  def index
    @languages = Language.paginate(:page => params[:page])
    display @languages
  end
end
