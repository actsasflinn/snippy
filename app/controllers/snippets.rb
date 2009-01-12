class Snippets < Application
  provides :xml, :js

  def index
    if params[:slug]
      @language = Language.first(:slug => params[:slug])
      snippets = @language.snippets
    else
      snippets = Snippet
    end

    @snippets = snippets.send(:paginate, {:page => params[:page]})
    display @snippets
  end

  def show(id)
    @snippet = Snippet.get(id)
    raise NotFound unless @snippet
    display @snippet
  end

  def new
    only_provides :html
    @snippet = Snippet.new
    display @snippet
  end

  def edit(id)
    only_provides :html
    @snippet = Snippet.get(id)
    raise NotFound unless @snippet
    display @snippet
  end

  def create(snippet)
    @snippet = Snippet.new(snippet)
    if @snippet.save
      redirect resource(@snippet), :message => {:notice => "Snippet was successfully created"}
    else
      message[:error] = "Snippet failed to be created"
      render :new
    end
  end

  def update(id, snippet)
    @snippet = Snippet.get(id)
    raise NotFound unless @snippet
    if @snippet.update_attributes(snippet)
       redirect resource(@snippet)
    else
      display @snippet, :edit
    end
  end

  def destroy(id)
    @snippet = Snippet.get(id)
    raise NotFound unless @snippet
    if @snippet.destroy
      redirect resource(:snippets)
    else
      raise InternalServerError
    end
  end
end # Snippets
