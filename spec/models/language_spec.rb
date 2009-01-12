require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Language do
  before do
    Language.all.destroy!
  end

  it "should have a name" do
    language = Language.create(:slug => 'nothing')
    language.errors[:name].should == ["Name must not be blank"]
  end

  it "should create a slug from name" do
    language = Language.create(:name => "Nothing")
    language.slug.should == 'nothing'
  end

  it "should have a unique name" do
    Language.create(:name => "Ruby", :slug => 'ruby')
    language = Language.create(:name => "Ruby", :slug => 'ruby')
    language.errors[:name].should == ["Name is already taken"]
  end

  it "should have a unique slug" do
    Language.create(:name => "Ruby", :slug => 'ruby')
    language = Language.create(:name => "Ruby", :slug => 'ruby')
    language.errors[:slug].should == ["Slug is already taken"]
  end
end