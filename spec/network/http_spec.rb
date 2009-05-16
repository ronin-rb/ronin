require 'ronin/network/http'

require 'spec_helper'

describe Network::HTTP do
  describe "HTTP.expand_options" do
    it "should added a default port and path" do
      options = {:host => 'example.com'}
      expanded_options = Network::HTTP.expand_options(options)

      expanded_options[:port].should == 80
      expanded_options[:path].should == '/'
    end

    it "should add the default proxy settings" do
      options = {:host => 'example.com'}
      expanded_options = Network::HTTP.expand_options(options)

      expanded_options[:proxy].should == Network::HTTP.proxy
    end

    it "should expand the :url option" do
      options = {:url => 'http://joe:secret@example.com:8080/bla?var'}
      expanded_options = Network::HTTP.expand_options(options)

      expanded_options[:url].should be_nil
      expanded_options[:host].should == 'example.com'
      expanded_options[:port].should == 8080
      expanded_options[:user].should == 'joe'
      expanded_options[:password].should == 'secret'
      expanded_options[:path].should == '/bla?var'
    end

    it "should add a default :path option for :url options" do
      options = {:url => 'http://example.com'}
      expanded_options = Network::HTTP.expand_options(options)

      expanded_options[:path].should == '/'
    end
  end

  describe "HTTP.request" do
    it "should handle Symbol names" do
      Network::HTTP.request(
        :get, :path => '/'
      ).class.should == Net::HTTP::Get
    end

    it "should handle String names" do
      Network::HTTP.request(
        'GET', :path => '/'
      ).class.should == Net::HTTP::Get
    end

    it "should raise an UnknownRequest exception for invalid names" do
      lambda {
        Network::HTTP.request(:bla)
      }.should raise_error(Network::HTTP::UnknownRequest)
    end

    it "should use a default path" do
      lambda {
        Network::HTTP.request(:get)
      }.should_not raise_error(ArgumentError)
    end

    it "should accept the :user option for Basic-Auth" do
      req = Network::HTTP.request(:get, :user => 'joe')

      req['authorization'].should == "Basic am9lOg=="
    end

    it "should accept the :user and :password options for Basic-Auth" do
      req = Network::HTTP.request(:get, :user => 'joe', :password => 'secret')

      req['authorization'].should == "Basic am9lOnNlY3JldA=="
    end
  end
end
