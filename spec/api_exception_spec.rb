require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Viddler::ApiException, ".new" do
  before(:each) do
    @exception = Viddler::ApiException.new("300", "The Description", "The Details")
  end
  
  it "sets code" do
    @exception.code.should == 300
  end
  
  it "sets description" do
    @exception.description.should == "The Description"
  end
  
  it "sets details" do
    @exception.details.should == "The Details"
  end
end

describe Viddler::ApiException, ".to_s" do
  before(:each) do
    @exception = Viddler::ApiException.new("300", "The Description", "The Details")
  end
  
  it "returns proper string" do
    @exception.to_s.should == '#300: The Description (The Details)'
  end
end