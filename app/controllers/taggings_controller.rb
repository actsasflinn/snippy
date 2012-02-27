class TaggingsController < ApplicationController
  respond_to :html, :xml, :json, :js

  # POST /taggings
  # POST /taggings.xml
  def create
    @tagging = Tagging.new(params[:tagging])
    @snippet = @tagging.snippet;
    @tagging.tag = Tag.find_or_create_by_name(params[:name])

    if @tagging.save
      @tagging.tag.taggings_count += 1  # counter cache column doesn't get updated with filter
      respond_with(@tagging, :notice => 'Tagging was successfully created.')
    else
      respond_with(@tagging, :status => :unprocessable_entity) do |format|
        format.js { render "create_error" }
      end
    end
  end

  # DELETE /taggings/1
  # DELETE /taggings/1.xml
  def destroy
    @tagging = Tagging.find(params[:id])
    @snippet = @tagging.snippet;
    @tagging.destroy

    respond_with(@tagging)
  end
end
