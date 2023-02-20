require 'spec_helper'
require 'ronin/cli/commands/http'
require_relative 'man_page_example'

require 'stringio'

describe Ronin::CLI::Commands::Http do
  include_examples "man_page"

  describe "#initialize" do
    it "must default #proxy to nil" do
      expect(subject.proxy).to be(nil)
    end

    it "must default #http_method to :get" do
      expect(subject.http_method).to be(:get)
    end

    it "must default #headers to an empty Hash" do
      expect(subject.headers).to eq({})
    end

    it "must default #user_agent to nil" do
      expect(subject.user_agent).to be(nil)
    end

    it "must default #query_params to an empty Hash" do
      expect(subject.query_params).to eq({})
    end

    it "must default #form_data to an empty Hash" do
      expect(subject.form_data).to eq({})
    end
  end

  let(:stdout) { StringIO.new }

  subject { described_class.new(stdout: stdout) }

  describe "#option_parser" do
    context "when --shell is given a non-http URL" do
      it do
        expect {
          subject.option_parser.parse(%w[--shell foo])
        }.to raise_error(OptionParser::InvalidArgument)
      end
    end
  end

  describe "#run" do
    context "when --shell is given" do
      let(:base_url) { 'https://example.com/' }
      let(:base_uri) { Addressable::URI.parse(base_url) }

      before do
        subject.option_parser.parse(['--shell', base_url])
      end

      it "must call #start_shell with the --shell argument" do
        expect(subject).to receive(:start_shell).with(base_uri)

        subject.run
      end
    end

    context "when --shell is not given" do
      let(:urls) do
        %w[
          https://example.com/url1
          https://example.com/url2
          https://example.com/url3
        ]
      end

      it "must pass the additional URLs to #process_value" do
        expect(subject).to receive(:process_value).with(urls[0])
        expect(subject).to receive(:process_value).with(urls[1])
        expect(subject).to receive(:process_value).with(urls[2])

        subject.run(*urls)
      end
    end
  end

  describe "#start_shell" do
    let(:proxy)      { 'https://proxy.example.com:8080' }
    let(:header1)    { 'X-Foo: foo' }
    let(:header2)    { 'X-Bar: bar' }
    let(:user_agent) { "Mozilla/5.0 Foo Bar" }

    before do
      subject.option_parser.parse(
        '--proxy', proxy,
        '--header', header1,
        '--header', header2,
        '--user-agent-string', user_agent
      )
    end

    let(:base_url) { 'https://example.com/' }

    it "must call HTTPShell.start with the given base_url, #proxy, #headers, and #user_agent" do
      expect(Ronin::CLI::HTTPShell).to receive(:start).with(
        base_url, proxy:      subject.proxy,
                  headers:    subject.headers,
                  user_agent: subject.user_agent
      )

      subject.start_shell(base_url)
    end
  end

  describe "#process_value" do
    let(:url) { 'https://example.com/' }
    let(:uri) { Addressable::URI.parse(url) }

    let(:response) { double('Net::HTTPResponse') }

    let(:chunk1) { "<html>\r\n  <body>\r\n    <p>Hello World" }
    let(:chunk2) { "</p>\r\n  </body>\r\n</html>\r\n" }

    it "must call Ronin::Support::Network::HTTP.request with the #http_method, URI, #proxy, #user_agent, URI's user, URI's password, #query_params, #headers, #body, #form_data" do
      expect(Ronin::Support::Network::HTTP).to receive(:request).with(
        subject.http_method, uri, proxy:        subject.proxy,
                                  user_agent:   subject.user_agent,
                                  query_params: subject.query_params,
                                  headers:      subject.headers,
                                  body:         subject.body,
                                  form_data:    subject.form_data
      ).and_yield(response)

      expect(response).to receive(:read_body).and_yield(chunk1).and_yield(chunk2)

      subject.process_value(url)

      expect(stdout.string).to eq(chunk1 + chunk2)
    end
  end

  describe "#process_value", :integration do
    let(:url) { 'https://example.com/' }
    let(:expected_response_body) { Net::HTTP.get(URI(url)) }

    it "must read and print the response body" do
      subject.process_value(url)

      expect(stdout.string).to eq(expected_response_body)
    end
  end

  describe "#print_response" do
    let(:http_version) { '1.1' }
    let(:status)       { '200' }
    let(:response) do
      double('Net::HTTPResponse', http_version: http_version,
                                  code:         status)
    end

    let(:chunk1) { "<html>\r\n  <body>\r\n    <p>Hello World" }
    let(:chunk2) { "</p>\r\n  </body>\r\n</html>\r\n" }

    context "when the --verbose option is given" do
      before do
        subject.option_parser.parse(%w[--verbose])
      end

      let(:header_name1)  { 'X-Foo' }
      let(:header_value1) { 'foo'   }
      let(:header_name2)  { 'X-Bar' }
      let(:header_value2) { 'bar'   }
      let(:headers) do
        {
          header_name1 => header_value1,
          header_name2 => header_value2
        }
      end

      it "must print the headers as well as the body of the response" do
        expect(response).to receive(:each_capitalized).and_yield(header_name1,header_value1).and_yield(header_name2,header_value2)
        expect(response).to receive(:read_body).and_yield(chunk1).and_yield(chunk2)

        subject.print_response(response)

        expect(stdout.string).to eq(
          [
          "HTTP/#{http_version} #{status}",
          "#{header_name1}: #{header_value1}",
          "#{header_name2}: #{header_value2}",
          '',
          "#{chunk1}#{chunk2}"
          ].join($/)
        )
      end
    end
  end
end
