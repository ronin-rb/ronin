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
end
