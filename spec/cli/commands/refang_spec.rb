require 'spec_helper'
require 'ronin/cli/commands/refang'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Refang do
  include_examples "man_page"

  describe "#process_value" do
    context "when given a defanged URL value" do
      let(:defanged) { 'hxxps://www[.]evil[.]com/foo/bar/baz' }
      let(:refanged) { 'https://www.evil.com/foo/bar/baz' }

      it "must print the re-fanged URL" do
        expect {
          subject.process_value(defanged)
        }.to output("#{refanged}#{$/}").to_stdout
      end
    end

    context "when given a defanged hostname value" do
      let(:defanged) { 'www[.]example[.]com' }
      let(:refanged) { 'www.example.com' }

      it "must print the re-fanged hostname" do
        expect {
          subject.process_value(defanged)
        }.to output("#{refanged}#{$/}").to_stdout
      end
    end

    context "when given a defanged IP address value" do
      let(:defanged) { '192[.]168[.]1[.]1' }
      let(:refanged) { '192.168.1.1' }

      it "must print the re-fanged IP address" do
        expect {
          subject.process_value(defanged)
        }.to output("#{refanged}#{$/}").to_stdout
      end
    end
  end
end
