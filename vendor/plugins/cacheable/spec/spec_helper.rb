$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'rubygems'
require 'mocha'

begin
  require 'redgreen'
rescue LoadError
  nil
end

CACHE_TOOLS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined? CACHE_TOOLS_ROOT
RAILS_ROOT = "#{CACHE_TOOLS_ROOT}/../../.."       unless defined? RAILS_ROOT
RAILS_ENV  = 'test'                               unless defined? RAILS_ENV

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

module ArmyGuyCacheSpecSetup
  def self.included(base)
    base.setup do 
      setup_cache_spec 
    end
  end

  def setup_cache_spec
    army_guys = []
    army_guys << { :name => 'Joe Snuffy', :rank => 'Pvt' }
    army_guys << { :name => 'Jane Snuffy', :rank => 'Pv2' }
    army_guys << { :name => 'Jack Dandy', :rank => 'Pfc' }
    army_guys << { :name => 'Carole Dandy', :rank => 'Spc' }
    army_guys.each do |attributes|
      ArmyGuy.create(attributes)
    end
  end
end

def cache_store
  if ENV.include?('with_memcache')
    [:mem_cache_store, ENV['with_memcache']]
  elsif ENV.include?('with_memcached')
    require 'memcached_store'
    [:memcached_store, ENV['with_memcached']]
  else
    :memory_store
  end
end

def setup_rails_database
  require "#{RAILS_ROOT}/config/environment"

  silence_warnings { Object.const_set "RAILS_CACHE", ActiveSupport::Cache.lookup_store(*cache_store) }

  # Only run if there is not already a connection
  unless ActiveRecord::Base.connected?
    db = YAML.load(IO.read("#{dir}/resources/config/database.yml"))
    ActiveRecord::Base.configurations = {'test' => db[ENV['DB'] || 'sqlite3']}
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  end

  ActiveRecord::Migration.verbose = false
  load "#{CACHE_TOOLS_ROOT}/spec/resources/schema.rb"

  require "#{CACHE_TOOLS_ROOT}/init"
end
