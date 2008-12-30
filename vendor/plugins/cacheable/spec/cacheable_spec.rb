require File.dirname(__FILE__) + '/spec_helper'
require 'cache_tools'
require 'activerecord'

setup_rails_database

class ArmyGuy < ActiveRecord::Base
  include Cacheable

  validates_uniqueness_of :name

  def after_save
    logger.debug('after_save ran')
  end

  def self.contrived(options = {})
    "contrived(#{options.inspect})"
  end

  def contrived(options = {})
    self.class.contrived(options)
  end
end

describe ArmyGuy do
  include ArmyGuyCacheSpecSetup

  describe "cache_id" do
    it 'make a single id key' do
      ArmyGuy.cache_id(:find, 1).should == 'ArmyGuy/find/1'
    end

    it 'make a multi-id key' do
      ArmyGuy.cache_id(:find, 1,2,3).should == 'ArmyGuy/find/1/2/3'
    end

    it 'make a shortcut key' do
      ArmyGuy.cache_id(:find, :first).should == 'ArmyGuy/find/first'
    end

    it 'make a custom key' do
      ArmyGuy.cache_id(:find, :last_by_created_at).should == 'ArmyGuy/find/last_by_created_at'
    end

    it 'make a parameterized key from arguments' do
      ArmyGuy.cache_id(:find, :all, :conditions => { :name => 'Joe Snuffy' }).should == 'ArmyGuy/find/all/conditions%5Bname%5D=Joe+Snuffy'
    end
  end

  describe "cached_find" do
    it 'gets a single id' do
      cached = ArmyGuy.cached_find(1)
      cached.should == ArmyGuy.find(1)
      cached.should == Rails.cache.read('ArmyGuy/find/1')
    end

    it 'gets a multiple ids' do
      cached = ArmyGuy.cached_find(1,2,3)
      cached.should == ArmyGuy.find(1,2,3)
      cached.should == Rails.cache.read('ArmyGuy/find/1/2/3')
    end

    it 'gets the :first shortcut' do
      cached = ArmyGuy.cached_find(:first)
      cached.should == ArmyGuy.find(:first)
      cached.should == Rails.cache.read('ArmyGuy/find/first')
    end

    it 'gets custom finder with custom key' do
      cached = ArmyGuy.cached_find(:last_by_created_at){ |u| u.last(:order => 'created_at') }
      cached.should == ArmyGuy.last(:order => 'created_at')
      cached.should == Rails.cache.read('ArmyGuy/find/last_by_created_at')
    end

    it 'gets arguments and options without a custom key' do
      conditions = { :name => 'Joe Snuffy' }
      cached = ArmyGuy.cached_find(:custom_key, :all, :conditions => conditions)
      cached.should == ArmyGuy.find(:all, :conditions => conditions)
      cached.should == Rails.cache.read('ArmyGuy/find/custom_key')
    end

    it 'gets arguments and options without a key' do
      conditions = { :name => 'Joe Snuffy' }
      cached = ArmyGuy.cached_find(:all, :conditions => conditions)
      cached.should == ArmyGuy.find(:all, :conditions => conditions)
      cached.should == Rails.cache.read('ArmyGuy/find/all/conditions%5Bname%5D=Joe+Snuffy')
    end
  end

  describe "cached_method" do
    it 'gets a contrived method result' do
      options = [{ :bar => 'baz' }]
      cached_method = ArmyGuy.cached_method(:contrived, :with => options)
      cached_method.should == ArmyGuy.contrived(*options)
      Rails.cache.read("ArmyGuy/contrived/bar=baz").should == ArmyGuy.contrived(*options)
    end

    it 'stores a cache with a custom key' do
      options = [{ :bar => 'baz' }]
      ArmyGuy.cached_method(:contrived, :with => options, :key => 'foo_bar')
      Rails.cache.read('ArmyGuy/contrived/foo_bar').should == ArmyGuy.contrived(*options)
    end

    it 'stores a record with a custom key' do
      options = [{ :bar => 'baz' }]
      joe_snuffy = ArmyGuy.find_or_create_by_name('Joe Snuffy')
      joe_snuffy.cached_method(:contrived, :with => options)
      Rails.cache.read("ArmyGuy/#{joe_snuffy.id}/contrived/bar=baz").should == joe_snuffy.contrived(*options)
    end
  end
end
