require 'spec_helper'
require 'ronin/cli/commands/bitsquat'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Bitsquat do
  include_examples "man_page"

  let(:domain) { 'example.com' }
  let(:bitflips) do
    %w[
        dxample.com
        gxample.com
        axample.com
        mxample.com
        uxample.com
        Example.com
        eyample.com
        ezample.com
        epample.com
        ehample.com
        eXample.com
        e8ample.com
        excmple.com
        exemple.com
        eximple.com
        exqmple.com
        exAmple.com
        exalple.com
        exaople.com
        exaiple.com
        exaeple.com
        exaMple.com
        exa-ple.com
        examqle.com
        examrle.com
        examtle.com
        examxle.com
        examPle.com
        exam0le.com
        exampme.com
        exampne.com
        examphe.com
        exampde.com
        exampLe.com
        exampld.com
        examplg.com
        exampla.com
        examplm.com
        examplu.com
        examplE.com
        example.bom
    ]
  end

  describe "#process_value" do
    it "must print all valid bitflipped domains by default" do
      expect {
        subject.process_value(domain)
      }.to output(bitflips.join($/) + $/).to_stdout
    end

    context "when --has-addresses is given", :integration do
      before { subject.options[:has_addresses] = true }

      let(:bitflips_with_addresses) do
        %w[
            axample.com
            Example.com
            ezample.com
            eXample.com
            exemple.com
            eximple.com
            exAmple.com
            exaMple.com
            examqle.com
            examPle.com
            exampLe.com
            exampla.com
            examplE.com
        ]
      end

      it "must only print bitflipped domains that have addresses" do
        expect {
          subject.process_value(domain)
        }.to output(bitflips_with_addresses.join($/) + $/).to_stdout
      end
    end

    context "when --registered is given", :integration do
      before { subject.options[:registered] = true }

      let(:registered_bitflips) do
        %w[
            axample.com
            Example.com
            eXample.com
            exemple.com
            eximple.com
            exAmple.com
            exaMple.com
            examqle.com
            examPle.com
            exampLe.com
            exampla.com
            examplE.com
        ]
      end

      it "must only print bitflipped domains that are registered" do
        expect {
          subject.process_value(domain)
        }.to output(registered_bitflips.join($/) + $/).to_stdout
      end
    end

    context "when --unregistered is given", :integration do
      before { subject.options[:unregistered] = true }

      let(:unregistered_bitflips) do
        %w[
            dxample.com
            gxample.com
            mxample.com
            uxample.com
            eyample.com
            ezample.com
            epample.com
            ehample.com
            e8ample.com
            excmple.com
            exqmple.com
            exalple.com
            exaople.com
            exaiple.com
            exaeple.com
            exa-ple.com
            examrle.com
            examtle.com
            examxle.com
            exam0le.com
            exampme.com
            exampne.com
            examphe.com
            exampde.com
            exampld.com
            examplg.com
            examplm.com
            examplu.com
            example.bom
        ]
      end

      it "must only print bitflipped domains that are unregistered" do
        expect {
          subject.process_value(domain)
        }.to output(unregistered_bitflips.join($/) + $/).to_stdout
      end
    end
  end

  describe "#each_bit_squat" do
    it "must yield Ronin::Support::Network::Host objects" do
      yielded_hosts = []

      subject.each_bit_squat(domain) do |host|
        yielded_hosts << host
      end

      expect(yielded_hosts).to all(be_kind_of(Ronin::Support::Network::Host))
    end

    it "must only yield valid host names" do
      yielded_hosts = []

      subject.each_bit_squat(domain) do |host|
        yielded_hosts << host
      end

      expect(yielded_hosts).to all(match(described_class::VALID_HOST_NAME))
    end

    it "must yield bit-flips of the given domain name" do
      yielded_hosts = []

      subject.each_bit_squat(domain) do |host|
        yielded_hosts << host
      end

      expect(yielded_hosts.map(&:name)).to eq(bitflips)
    end
  end
end
