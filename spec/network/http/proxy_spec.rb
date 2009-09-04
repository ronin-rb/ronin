require 'ronin/network/http/proxy'

require 'spec_helper'

describe Network::HTTP::Proxy do
  before(:each) do
    @proxy = Network::HTTP::Proxy.new
  end

  it "should behave like a Hash" do
    @proxy[:host] = 'example.com'
    @proxy[:host].should == 'example.com'
  end

  it "should not have a host by default" do
    @proxy.host.should be_nil
  end

  it "should have a default port" do
    @proxy.port.should == 8080
  end

  it "should be disabled by default" do
    @proxy.should_not be_enabled
  end

  it "should reset the host, port, user and password when disabled" do
    @proxy[:host] = 'example.com'
    @proxy[:port] = 9001
    @proxy[:user] = 'joe'
    @proxy[:password] = 'lol'

    @proxy.disable!

    @proxy[:host].should be_nil
    @proxy[:port].should == 8080
    @proxy[:user].should be_nil
    @proxy[:password].should be_nil
  end

  it "should convert host-names to Strings" do
    @proxy.host = :"example.com"
    @proxy.host.should == 'example.com'
  end

  it "should convert ports to Integers" do
    @proxy.port = '8001'
    @proxy.port.should == 8001
  end

  it "should return a URI::HTTP representing the proxy" do
    @proxy[:host] = 'example.com'
    @proxy[:port] = 9001
    @proxy[:user] = 'joe'
    @proxy[:password] = 'lol'

    url = @proxy.url

    url.host.should == 'example.com'
    url.port.should == 9001
    url.user.should == 'joe'
    url.password.should == 'lol'
  end

  it "should return the host-name when converted to a String" do
    @proxy[:host] = 'example.com'
    @proxy.to_s.should == 'example.com'
  end

  it "should return an empty String when there is no host-name" do
    @proxy.to_s.should be_empty
  end
end
