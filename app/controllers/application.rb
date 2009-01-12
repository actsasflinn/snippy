class Application < Merb::Controller
  before :sidebar

  def sidebar
    @sidebar_languages = Language.paginate(:page => 1)
  end
end