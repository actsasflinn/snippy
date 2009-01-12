require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a language exists" do
  Language.all.destroy!
  Language.create(:name => 'Ruby', :slug => 'ruby')
end

describe "resource(:languages)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:languages))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of languages" do
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a language exists" do
    before(:each) do
      @response = request(resource(:languages))
    end
    
    it "has a list of languages" do
      @response.should have_xpath("//ul/li")
    end
  end
end
