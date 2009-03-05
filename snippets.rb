require 'rubygems'
require 'sinatra'
require 'tokyo_tyrant'
require 'lib/tyrant_object'
require 'models/snippet'

$tyrant = TokyoTyrant::Table.new('127.0.0.1', 1978)

get '/' do
  'Snippets'
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
