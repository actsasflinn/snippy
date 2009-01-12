require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Snippet do
  before do
    Snippet.all.destroy!
  end

  it "should have a body" do
    snippet = Snippet.create(:body => nil)
    snippet.errors[:body].should == ["Body must not be blank"]
  end

  it "should have a language" do
    snippet = Snippet.create(:body => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
    snippet.errors[:language_id].should == ["Language must not be blank"]
  end
end