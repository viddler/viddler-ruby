require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Viddler::Client, ".new" do
  it "sets API key" do
    Viddler::Client.new('abc123').api_key.should == 'abc123'
  end
end

describe Viddler::Client, "#authenticate!" do
  before(:each) do
    @client = Viddler::Client.new('abc123')
    @client.stub!(:get).and_return({
      'auth' => {
        'sessionid' => 'mysess'
      }
    })
  end
  
  it "calls GET viddler.users.auth with username and password" do
    @client.should_receive(:get).with('viddler.users.auth', :password => 'pass', :user => 'user')
    @client.authenticate! 'user', 'pass'
  end
  
  it "sets sessionid" do
    @client.authenticate! 'user', 'pass'
    @client.sessionid.should == 'mysess'
  end
  
  it "returns sessionid" do
    @client.authenticate!('user', 'pass').should == 'mysess'
  end
end

describe Viddler::Client, "#authenticated?" do
  before(:each) do
    @client = Viddler::Client.new('abc123')
  end
  
  it "returns true if a sessionid is set" do
    @client.sessionid = 'mysess'
    @client.should be_authenticated
  end
  
  it "returns false if a sessionid is not set" do
    @client.should_not be_authenticated
  end
end

describe Viddler::Client, "#get" do
  before(:each) do
    @client = Viddler::Client.new('abc123')
    RestClient.stub!(:get).and_return('{"response":["hello", "howdy"]}')
  end
  
  it "calls RestClient.get with proper params" do
    RestClient.should_receive(:get).with('http://api.viddler.com/api/v2/viddler.api.getInfo.json', :params => hash_including(:param1 => 'asdf', :param2 => true))
    @client.get('viddler.api.getInfo', :param1 => 'asdf', :param2 => true)
  end
  
  it "returns result of JSON.parse(response)" do
    JSON.stub!(:parse).and_return('abc')
    @client.get('method').should == 'abc'
  end
  
  it "includes API key" do
    RestClient.should_receive(:get).with(anything, :params => hash_including(:api_key => 'abc123'))
    @client.get('viddler.api.getInfo')
  end
  
  it "raises ApiException if an error occurs" do
    error = RestClient::ExceptionWithResponse.new '{"error":{"code":"9","description":"session invalid","details":"details"}}'
    RestClient.stub!(:get).and_raise(error)
    lambda {@client.get('viddler.api.getInfo')}.should raise_error(Viddler::ApiException, "#9: session invalid (details)")
  end
  
  context "with authenticated client" do
    before(:each) do
      @client.sessionid = "mysess"
    end
    
    it "calls RestClient.get with sessionid" do
      RestClient.should_receive('get').with(anything, :params => hash_including(:sessionid => 'mysess'))
      @client.get('viddler.api.getInfo', :something => 'yes')
    end
  end
end

describe Viddler::Client, "#post" do
  before(:each) do
    @client = Viddler::Client.new('abc123')
    RestClient.stub!(:post).and_return('{"response":["hello","howdy"]}')
  end
  
  it "calls RestClient.post with proper params" do
    RestClient.should_receive(:post).with('http://api.viddler.com/api/v2/viddler.api.getInfo.json', :params => hash_including(:param1 => 'asdf', :param2 => true))
    @client.post('viddler.api.getInfo', :param1 => 'asdf', :param2 => true)
  end
  
  it "returns result of JSON.parse(response)" do
    JSON.stub!(:parse).and_return('abc')
    @client.post('method').should == 'abc'
  end
  
  it "includes API key" do
    RestClient.should_receive(:post).with(anything, :params => hash_including(:api_key => 'abc123'))
    @client.post('viddler.api.getInfo')
  end
  
  it "raises ApiException if an error occurs" do
    error = RestClient::ExceptionWithResponse.new '{"error":{"code":"9","description":"session invalid","details":"details"}}'
    RestClient.stub!(:post).and_raise(error)
    lambda {@client.post('viddler.api.getInfo')}.should raise_error(Viddler::ApiException, "#9: session invalid (details)")
  end
  
  context "with authenticated client" do
    before(:each) do
      @client.sessionid = "mysess"
    end
    
    it "calls RestClient.post with sessionid" do
      RestClient.should_receive('post').with(anything, :params => hash_including(:sessionid => 'mysess'))
      @client.post('viddler.api.getInfo', :something => 'yes')
    end
  end
end

describe Viddler::Client, "#upload" do
  before(:each) do
    @client = Viddler::Client.new('abc123')
    @file   = mock(File)
    @client.sessionid = 'mysess'
    
    RestClient.stub!(:post).and_return('{"response":["hello","howdy"]}')
    @client.stub!(:get).and_return({"upload" => {"endpoint" => "http://upload.viddler.com/upload.json"}})
  end
  
  it "calls get with viddler.videos.prepareUpload" do
    @client.should_receive(:get).with('viddler.videos.prepareUpload')
    @client.upload @file, :param1 => 'asdf', :param2 => true
  end
  
  it "calls RestClient.post with endpoint, params, and file" do
    RestClient.should_receive(:post).with('http://upload.viddler.com/upload.json', hash_including(:param1 => 'asdf', :param2 => true, :file => @file))
    @client.upload @file, :param1 => 'asdf', :param2 => true
  end
  
  it "includes sessionid" do
    RestClient.should_receive(:post).with(anything, hash_including(:sessionid => 'mysess'))
    @client.upload @file, :param1 => 'asdf', :param2 => true
  end
  
  it "includes API key" do
    RestClient.should_receive(:post).with(anything, hash_including(:api_key => 'abc123'))
    @client.upload @file, :param1 => 'asdf', :param2 => true
  end
  
  it "returns result of JSON.parse" do
    JSON.stub!(:parse).and_return('asdfasdf')
    @client.upload(@file, :param1 => 'asdf').should == 'asdfasdf'
  end
  
  it "raises an ApiException on API error" do
    error = RestClient::ExceptionWithResponse.new '{"error":{"code":"9","description":"session invalid","details":"details"}}'
    RestClient.stub!(:post).and_raise(error)
    lambda {@client.upload(@file, :param1 => 'asdf')}.should raise_error(Viddler::ApiException, "#9: session invalid (details)")
  end
end