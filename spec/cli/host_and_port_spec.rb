require 'spec_helper'
require 'ronin/cli/host_and_port'

describe Ronin::CLI::HostAndPort do
  class TestHostAndPort
    include Ronin::CLI::HostAndPort
  end

  subject { TestHostAndPort.new }

  let(:host) { 'www.example.com' }
  let(:port) { 443 }

  describe "#host_and_port" do
    let(:string) { "#{host}:#{port}" }

    it "must parse the given 'host:port' pair and return a String and an Integer" do
      parsed_host, parsed_port = subject.host_and_port(string)

      expect(parsed_host).to eq(host)
      expect(parsed_port).to eq(port)
    end
  end

  describe "#host_and_port_from_url" do
    context "when the URL does not have an explicit port" do
      let(:url) { "https://#{host}/" }

      it "must return the host and default port from the URL" do
        url_host, url_port = subject.host_and_port_from_url(url)

        expect(url_host).to eq(host)
        expect(url_port).to eq(443)
      end
    end

    context "when the URL has an explicit port" do
      let(:port) { 8000 }
      let(:url)  { "https://#{host}:#{port}/" }

      it "must return the host and port from the URL" do
        url_host, url_port = subject.host_and_port_from_url(url)

        expect(url_host).to eq(host)
        expect(url_port).to eq(port)
      end
    end

    context "when the URL has an IDN host name" do
      let(:idn_host)      { "www.詹姆斯.com" }
      let(:punycode_host) { "www.xn--8ws00zhy3a.com" }
      let(:url)           { "https://#{idn_host}/" }

      it "must return the punycode/ASCII host name and port from the URL" do
        url_host, url_port = subject.host_and_port_from_url(url)

        expect(url_host).to eq(punycode_host)
        expect(url_port).to eq(443)
      end
    end
  end
end
