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
      :auth => {
        :sessionid => 'mysess'
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
    RestClient.should_receive(:get).with(Viddler::Client::DEFAULT_ENDPOINT + 'viddler.api.getInfo.json', :param1 => 'asdf', :param2 => true)
    @client.get('viddler.api.getInfo', :param1 => 'asdf', :param2 => true)
  end
  
  it "returns result of JSON.parse(response)" do
    JSON.stub!(:parse).and_return('abc')
    
    @client.get('method').should == 'abc'
  end
  
  it "raises ApiException if an error occurs"
  
  context "with authenticated client" do
    before(:each) do
      @client.sessionid = "mysess"
    end
    
    it "calls RestClient.get with sessionid" do
      RestClient.should_receive('get').with(anything, hash_including(:sessionid => 'mysess'))
      @client.get('viddler.api.getInfo', :something => 'yes')
    end
  end
end