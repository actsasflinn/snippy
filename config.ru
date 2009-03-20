require 'rubygems'
require 'rack'
require 'rack/contrib'
require 'sinatra'
require 'snippets'

use Rack::JSONP

run Sinatra::Application
