require 'tokyo_tyrant'
require 'lib/tyrant_object'
require 'models/snippet'

set :run, false
set :environment, :production
disable :logging

get '/' do
  Snippet.paginate(:page => params[:page]).to_json
end

get '/:id' do
  snippet = Snippet[params[:id]]
  snippet.to_json
end

post '/' do
  snippet = Snippet.new(params[:snippet])
  redirect snippet_url(snippet)
end

# hmmm this is starting to look a lot like activerecord / datamapper
put '/:id' do
  snippet = Snippet[params[:id]]
  snippet.attributes = params[:snippet]
  redirect snippet_url(snippet)
end

delete ':/id' do
  Snippet[params[:id]] = nil
  redirect '/'
end
