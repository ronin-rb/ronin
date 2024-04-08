require 'spec_helper'
require 'ronin/cli/commands/iprange'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Iprange do
  include_examples "man_page"

  describe "#process_value" do
    let(:string) { '10.1.1.1/24' }
    let(:addresses) do
      (0..255).map { |d| "10.1.1.#{d}" }
    end

    it "must print every IP in the range by default" do
      expect {
        subject.process_value(string)
      }.to output(
        addresses.join($/) + $/
      ).to_stdout
    end

    context "when the --size option is also given" do
      before { subject.options[:size] = true }

      it "must print the size of the IP range instead" do
        expect {
          subject.process_value(string)
        }.to output(
          "#{addresses.size}#{$/}"
        ).to_stdout
      end
    end
  end

  describe "#process_ip_range" do
    shared_examples_for "#process_ip_range examples" do
      it "must print every IP in the range by default" do
        expect {
          subject.process_ip_range(ip_range)
        }.to output(
          addresses.join($/) + $/
        ).to_stdout
      end

      context "when the --size option is also given" do
        before { subject.options[:size] = true }

        it "must print the size of the IP range instead" do
          expect {
            subject.process_ip_range(ip_range)
          }.to output(
            "#{addresses.size}#{$/}"
          ).to_stdout
        end
      end
    end

    context "when given a Ronin::Support::Network::IPRange" do
      let(:string)   { '10.1.1.1/24' }
      let(:ip_range) { Ronin::Support::Network::IPRange.new(string) }
      let(:addresses) do
        (0..255).map { |d| "10.1.1.#{d}" }
      end

      include_context "#process_ip_range examples"
    end

    context "when given a Ronin::Support::Network::IPRange::Range" do
      let(:first)    { '10.0.0.127' }
      let(:last)     { '10.0.1.127' }
      let(:ip_range) { Ronin::Support::Network::IPRange::Range.new(first,last) }
      let(:addresses) do
        (127..255).map { |d| "10.0.0.#{d}" } +
          (0..127).map { |d| "10.0.1.#{d}" }
      end

      include_context "#process_ip_range examples"
    end
  end
end
