require 'spec_helper'
require 'ronin/cli/commands/defang'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Defang do
  include_examples "man_page"

  describe "#process_value" do
    context "when given a refanged URL value" do
      let(:url) { 'https://www.evil.com/foo/bar/baz' }
      let(:defanged) { 'hxxps[://]www[.]evil[.]com/foo/bar/baz' }

      it "must print the defanged URL" do
        expect {
          subject.process_value(url)
        }.to output("#{defanged}#{$/}").to_stdout
      end
    end

    context "when given a refanged hostname value" do
      let(:host) { 'www.example.com' }
      let(:defanged) { 'www[.]example[.]com' }

      it "must print the defanged hostname" do
        expect {
          subject.process_value(host)
        }.to output("#{defanged}#{$/}").to_stdout
      end
    end

    context "when given a refanged IP address value" do
      let(:ip) { '192.168.1.1' }
      let(:defanged) { '192[.]168[.]1[.]1' }

      it "must print the defanged IP address" do
        expect {
          subject.process_value(ip)
        }.to output("#{defanged}#{$/}").to_stdout
      end
    end
  end
end
