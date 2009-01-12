require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a snippet exists" do
  # Need better mocking
  language = Language.first(:name => 'Plain Text') || Language.create(:name => 'Plain Text')
  Snippet.all.destroy!
  Snippet.create(:body => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                 :language_id => language.id)
end

describe "resource(:snippets)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:snippets))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of snippets" do
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a snippet exists" do
    before(:each) do
      @response = request(resource(:snippets))
    end
    
    it "has a list of snippets" do
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Snippet.all.destroy!
      @response = request(resource(:snippets), :method => "POST", 
        :params => { :snippet => { 
          :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          :language_id => 1
        }})
    end
    
    it "redirects to resource(:snippets)" do
      @response.should redirect_to(resource(Snippet.first), :message => {:notice => "snippet was successfully created"})
    end
    
  end
end

describe "resource(@snippet)" do 
  describe "a successful DELETE", :given => "a snippet exists" do
     before(:each) do
       @response = request(resource(Snippet.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:snippets))
     end

   end
end

describe "resource(:snippets, :new)" do
  before(:each) do
    @response = request(resource(:snippets, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@snippet, :edit)", :given => "a snippet exists" do
  before(:each) do
    @response = request(resource(Snippet.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@snippet)", :given => "a snippet exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Snippet.first))
    end
  
    it "responds successfully" do
      require 'pp'
      pp @response
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @snippet = Snippet.first
      @response = request(resource(@snippet), :method => "PUT", 
        :params => { :snippet => {:id => @snippet.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@snippet))
    end
  end
  
end

