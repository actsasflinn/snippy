class TaggingsController < ApplicationController
  # POST /taggings
  # POST /taggings.xml
  def create
    @tagging = Tagging.new(params[:tagging])
    @tagging.tag = Tag.find_or_create_by_name(params[:name])

    respond_to do |format|
      if @tagging.save
        @tagging.tag.taggings_count += 1  # counter cache column doesn't get updated with filter
        flash[:notice] = 'Tagging was successfully created.'
        format.html { redirect_to(@tagging) }
        format.xml  { render :xml => @tagging, :status => :created, :location => @tagging }
        format.json { render :json => @tagging, :callback => params[:callback] }
        format.js   do
          render :update do |page|
            page.insert_html(:bottom, :taggings, :partial => "tagging")
            page[@tagging].visual_effect(:highlight, :duration => 5.0)
            page[:taggings_count].replace_html pluralize(@tagging.snippet.taggings.count, 'Tags')
          end
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tagging.errors, :status => :unprocessable_entity }
        format.json { render :json => @tagging.errors, :callback => params[:callback] }
        format.js   { render(:update){ |page| page[:new_tagging].visual_effect(:shake) } }
      end
    end
  end

  # DELETE /taggings/1
  # DELETE /taggings/1.xml
  def destroy
    @tagging = Tagging.find(params[:id])
    @tagging.destroy

    respond_to do |format|
      format.html { redirect_to(taggings_url) }
      format.xml  { head :ok }
      format.json { render :json => @tagging, :callback => params[:callback] }
      format.js   { render(:update){ |page|
        page[@tagging].visual_effect(:fade)
        page[:taggings_count].replace_html pluralize(@tagging.snippet.taggings.count, 'Tags')
      } }
    end
  end
end
