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