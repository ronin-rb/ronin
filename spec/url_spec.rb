require 'spec_helper'

require 'ronin/url'

describe URL do
  it "should have a default path" do
    url = URL.new

    url.path.should == ''
  end

  it "should have a host String" do
    url = URL.new(:host_name => HostName.new(:address => 'www.example.com'))

    url.host.should == 'www.example.com'
  end

  it "should be convertable to a String" do
    url = URL.new(
      :scheme => URLScheme.new(:name => 'https'),
      :host_name => HostName.new(:address => 'www.example.com'),
      :port => TCPPort.new(:number => 8080),
      :path => '/path',
      :query_string => 'q=1',
      :fragment => 'frag'
    )

    url.to_s.should == 'https://www.example.com:8080/path?q=1#frag'
  end

  describe "parse" do
    before(:all) do
      @url = URL.parse('https://www.example.com:8080/path?q=1#frag')
    end

    it "should parse URL schemes" do
      @url.scheme.should_not be_nil
      @url.scheme.name.should == 'https'
    end

    it "should parse host names" do
      @url.host_name.address.should == 'www.example.com'
    end

    it "should parse port numbers" do
      @url.port.number.should == 8080
    end

    it "should parse paths" do
      @url.path.should == '/path'
    end

    it "should parse query strings" do
      @url.query_string.should == 'q=1'
    end

    it "should parse URL fragments" do
      @url.fragment.should == 'frag'
    end
  end

  describe "to_uri" do
    before(:all) do
      @url = URL.parse('https://www.example.com:8080/path?q=1#frag')
      @uri = @url.to_uri
    end

    it "should convert the scheme" do
      @uri.scheme.should == 'https'
    end
    
    it "should convert the host name" do
      @uri.host.should == 'www.example.com'
    end

    it "should convert the port number" do
      @uri.port.should == 8080
    end

    it "should convert the path" do
      @uri.path.should == '/path'
    end

    it "should convert the query string" do
      @uri.query.should == 'q=1'
    end

    it "should convert the fragment" do
      @uri.fragment.should == 'frag'
    end
  end
end
