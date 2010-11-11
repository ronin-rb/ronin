require 'spec_helper'

require 'ronin/url'

describe URL do
  let(:scheme) { 'https' }
  let(:host_name) { 'www.example.com' }
  let(:port) { 8080 }
  let(:path) { '/path' }
  let(:query_params) { {'q' => '1'} }
  let(:query_string) { 'q=1' }
  let(:fragment) { 'frag' }

  let(:uri) do
    URI::HTTPS.build(
      :scheme => scheme,
      :host => host_name,
      :port => port,
      :path => path,
      :query => query_string,
      :fragment => fragment
    )
  end

  it "should have a default path" do
    url = URL.new

    url.path.should == ''
  end

  it "should have a host String" do
    url = URL.new(:host_name => {:address => host_name})

    url.host.should == host_name
  end

  it "should be convertable to a String" do
    url = URL.new(
      :scheme => {:name => scheme},
      :host_name => {:address => host_name},
      :port => {:number => port},
      :path => path,
      :query_string => query_string,
      :fragment => fragment
    )

    url.to_s.should == uri.to_s
  end

  describe "from" do
    before(:all) do
      @url = URL.from(uri)
    end

    it "should parse URL schemes" do
      @url.scheme.should_not be_nil
      @url.scheme.name.should == scheme
    end

    it "should parse host names" do
      @url.host_name.address.should == host_name
    end

    it "should parse port numbers" do
      @url.port.number.should == port
    end

    it "should parse paths" do
      @url.path.should == path
    end

    it "should parse query strings" do
      @url.query_string.should == query_string
    end

    it "should parse URL fragments" do
      @url.fragment.should == fragment
    end
  end

  describe "to_uri" do
    before(:all) do
      @url = URL.parse('https://www.example.com:8080/path?q=1#frag')
      @uri = @url.to_uri
    end

    it "should convert the scheme" do
      @uri.scheme.should == scheme
    end
    
    it "should convert the host name" do
      @uri.host.should == host_name
    end

    it "should convert the port number" do
      @uri.port.should == port
    end

    it "should convert the path" do
      @uri.path.should == path
    end

    it "should convert the query string" do
      @uri.query.should == query_string
    end

    it "should convert the fragment" do
      @uri.fragment.should == fragment
    end
  end
end
