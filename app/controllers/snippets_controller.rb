class SnippetsController < ApplicationController
  # GET /snippets
  # GET /snippets.xml
  def index
    if params[:q].blank?
      @snippets = Snippet.language(params[:language_id]).tag(params[:tag_id]).cached_paginate(:page => params[:page], :include => [:taggings, :language], :order => 'snippets.created_at desc')
    else
      @snippets = Snippet.cached_search(params[:q]).compact
    end

    @language = Language[params[:language_id]] unless params[:language_id].blank?
    @tag = Tag[params[:tag_id]] unless params[:tag_id].blank?

    respond_to do |format|
      format.html # index.html.erb
      format.rss  # index.rss.builder
      format.xml  { render :xml => @snippets }
      format.json { render :json => @snippets, :callback => params[:callback] }
    end
  end

  # GET /snippets/1
  # GET /snippets/1.xml
  def show
    @snippet = Snippet[params[:id]]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @snippet }
      format.json { render :json => @snippet }
      format.text { render :text => @snippet.body, :callback => params[:callback] }
    end
  end

  # GET /snippets/new
  # GET /snippets/new.xml
  def new
    @snippet = Snippet.new(:language => Language.find_by_slug('ruby_on_rails'))

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @snippet }
      format.json { render :json => @snippet, :callback => params[:callback] }
    end
  end

  # GET /snippets/1/edit
  def edit
    @snippet = Snippet.find(params[:id])
  end

  # POST /snippets
  # POST /snippets.xml
  def create
    @snippet = Snippet.new(params[:snippet])

    respond_to do |format|
      if @snippet.save
        flash[:notice] = 'Snippet was successfully created.'
        format.html { redirect_to(@snippet) }
        format.xml  { render :xml => @snippet, :status => :created, :location => @snippet }
        format.json { render :json => @snippet, :callback => params[:callback] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
        format.json { render :json => @snippet.errors, :callback => params[:callback] }
      end
    end
  end

  # PUT /snippets/1
  # PUT /snippets/1.xml
  def update
    @snippet = Snippet.find(params[:id])

    respond_to do |format|
      if @snippet.update_attributes(params[:snippet])
        flash[:notice] = 'Snippet was successfully updated.'
        format.html { redirect_to(@snippet) }
        format.xml  { head :ok }
        format.json { render :json => @snippet, :callback => params[:callback] }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
        format.json { render :json => @snippet.errors, :callback => params[:callback] }
      end
    end
  end
end
