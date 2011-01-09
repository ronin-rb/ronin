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

  before(:all) do
    @uri = URI::HTTPS.build(
      :scheme => scheme,
      :host => host_name,
      :port => port,
      :path => path,
      :query => query_string,
      :fragment => fragment
    )

    @url = URL.create(
      :scheme => {:name => scheme},
      :host_name => {:address => host_name},
      :port => {:number => port},
      :path => path,
      :fragment => fragment,
      :query_params => [{
        :name => query_params.keys[0],
        :value => query_params.values[0]
      }]
    )
  end

  it "should have a host String" do
    url = URL.new(:host_name => {:address => host_name})

    url.host.should == host_name
  end

  it "should be convertable to a String" do
    @url.to_s.should == @uri.to_s
  end

  describe "[]" do
    it "should query URLs using URIs" do
      URL[@uri].should == @url
    end

    it "should query URLs using Strings" do
      URL[@uri.to_s].should == @url
    end

    it "should still treat Integer arguments as indexes" do
      URL[0].should == @url
    end
  end

  describe "from" do
    subject { URL.from(@uri) }

    it "should parse URL schemes" do
      subject.scheme.should_not be_nil
      subject.scheme.name.should == scheme
    end

    it "should parse host names" do
      subject.host_name.address.should == host_name
    end

    it "should parse port numbers" do
      subject.port.number.should == port
    end

    it "should parse paths" do
      subject.path.should == path
    end

    it "should parse query strings" do
      subject.query_string.should == query_string
    end

    it "should parse URL fragments" do
      subject.fragment.should == fragment
    end

    it "should normalize the paths of HTTP URIs" do
      uri = URI('http://www.example.com')
      url = URL.from(uri)

      url.path.should == '/'
    end
  end

  describe "#to_uri" do
    subject { @url.to_uri }

    it "should convert the scheme" do
      subject.scheme.should == scheme
    end
    
    it "should convert the host name" do
      subject.host.should == host_name
    end

    it "should convert the port number" do
      subject.port.should == port
    end

    it "should convert the path" do
      subject.path.should == path
    end

    it "should convert the query string" do
      subject.query.should == query_string
    end

    it "should omit the query string if there are no query params" do
      new_url = URL.parse('https://www.example.com:8080/path')
      new_uri = new_url.to_uri

      new_uri.query.should be_nil
    end

    it "should convert the fragment" do
      subject.fragment.should == fragment
    end
  end
end
