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

    @url = URL.new(
      :scheme => URLScheme.first_or_create(:name => scheme),
      :host_name => HostName.first_or_create(:address => host_name),
      :port => TCPPort.first_or_create(:number => port),
      :path => path,
      :fragment => fragment
    )

    @url.query_params.new(
      :name => URLQueryParamName.first_or_create(
        :name => query_params.keys[0]
      ),
      :value => query_params.values[0]
    )

    @url.save
  end

  it "should have a host String" do
    url = URL.new(:host_name => {:address => host_name})

    url.host.should == host_name
  end

  it "should be convertable to a String" do
    @url.to_s.should == @uri.to_s
  end

  describe "extract" do
    subject { described_class }

    let(:url1) { subject.parse("http://example.com/page.php?x=1&y=2") }
    let(:url2) { subject.parse("ssh://alice@example.com") }
    let(:text) { "URIs: #{url1}, #{url2}" }

    it "should extract multiple URLs from text" do
      subject.extract(text).should == [url1, url2]
    end

    it "should yield the extracted URLs if a block is given" do
      urls = []

      subject.extract(text) { |url| urls << url }

      urls.should == [url1, url2]
    end

    it "should ignore non-absolute URIs" do
      subject.extract('foo: bar').should be_empty
    end
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

  describe "#to_s" do
    subject { @url.to_s }

    it "should convert the URL back into a String URI" do
      subject.should == @uri.to_s
    end
  end

  describe "#inspect" do
    subject { @url.inspect }

    it "should include the full URL" do
      subject.should include(@uri.to_s)
    end
  end
end
