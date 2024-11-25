require 'spec_helper'
require 'ronin/cli/commands/defang'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Defang do
  include_examples "man_page"

  describe "#process_value" do
    context "when given a refanged URL value" do
      let(:refanged) { 'https://www.evil.com/foo/bar/baz' }
      let(:defanged) { 'hxxps[://]www[.]evil[.]com/foo/bar/baz' }

      it "must print the de-fanged URL" do
        expect {
          subject.process_value(refanged)
        }.to output("#{defanged}#{$/}").to_stdout
      end
    end

    context "when given a refanged hostname value" do
      let(:refanged) { 'www.example.com' }
      let(:defanged) { 'www[.]example[.]com' }

      it "must print the de-fanged hostname" do
        expect {
          subject.process_value(refanged)
        }.to output("#{defanged}#{$/}").to_stdout
      end
    end

    context "when given a refanged IP address value" do
      let(:refanged) { '192.168.1.1' }
      let(:defanged) { '192[.]168[.]1[.]1' }

      it "must print the de-fanged IP address" do
        expect {
          subject.process_value(refanged)
        }.to output("#{defanged}#{$/}").to_stdout
      end
    end
  end
end
