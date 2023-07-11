require 'spec_helper'
require 'ronin/cli/commands/typosquat'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Typosquat do
  include_examples "man_page"

  let(:domain) { 'example.com' }
  let(:typos) do
    %w[
      examplle.com
    ]
  end

  describe "#process_value" do
    it "must print all valid typoped domains by default" do
      expect {
        subject.process_value(domain)
      }.to output(typos.join($/) + $/).to_stdout
    end

    context "when --has-addresses is given", :integration do
      before { subject.options[:has_addresses] = true }

      let(:typos_with_addresses) do
        %w[
          examplle.com
        ]
      end

      it "must only print typoped domains that have addresses" do
        expect {
          subject.process_value(domain)
        }.to output(typos_with_addresses.join($/) + $/).to_stdout
      end
    end

    context "when --registered is given", :integration do
      before { subject.options[:registered] = true }

      let(:registered_typos) do
        %w[
          examplle.com
        ]
      end

      it "must only print typoped domains that are registered" do
        expect {
          subject.process_value(domain)
        }.to output(registered_typos.join($/) + $/).to_stdout
      end
    end

    context "when --unregistered is given", :integration do
      before { subject.options[:unregistered] = true }

      let(:unregistered_typos) do
        %w[]
      end

      it "must only print typoped domains that are unregistered" do
        expect {
          subject.process_value(domain)
        }.to_not output.to_stdout
      end
    end
  end

  describe "#each_typo_squat" do
    it "must yield Ronin::Support::Network::Domain objects" do
      yielded_domains = []

      subject.each_typo_squat(domain) do |domain|
        yielded_domains << domain
      end

      expect(yielded_domains).to all(be_kind_of(Ronin::Support::Network::Domain))
    end

    it "must yield typos of the given domain name" do
      yielded_domains = []

      subject.each_typo_squat(domain) do |domain|
        yielded_domains << domain
      end

      expect(yielded_domains.map(&:name)).to eq(typos)
    end
  end
end
