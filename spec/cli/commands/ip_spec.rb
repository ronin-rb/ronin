require 'spec_helper'
require 'ronin/cli/commands/ip'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Ip do
  include_examples "man_page"

  let(:localhost) { "127.0.0.1" }

  describe "#process_value" do
    context "when -r option is given" do
      before { subject.options[:reverse] = true }

      it "will reverse an IPv4 address" do
        expect{ subject.process_value(localhost) }.to output("1.0.0.127.in-addr.arpa\n").to_stdout
      end
    end

    context "when --hex option is given" do
      before { subject.options[:hex] = true }

      it "will convert an IPv4 address to hexadecimal" do
        expect{ subject.process_value(localhost) }.to output("0x7f000001\n").to_stdout
      end
    end

    context "when --decimal option is given" do
      before { subject.options[:decimal] = true }

      it "will convert an IPv4 address to decimal" do
        expect{ subject.process_value(localhost) }.to output("2130706433\n").to_stdout
      end
    end

    context "when --octal option is given" do
      before { subject.options[:octal] = true }

      it "will convert an IPv4 address to octal" do
        expect{ subject.process_value(localhost) }.to output("017700000001\n").to_stdout
      end
    end

    context "when --binary option is given" do
      before { subject.options[:binary] = true }

      it "will convert an IPv4 address to binary" do
        expect{ subject.process_value(localhost) }.to output("1111111000000000000000000000001\n").to_stdout
      end
    end

    context "when --octal-octet option is given" do
      before { subject.options[:octal_octet] = true }

      it "will convert an IPv4 address to octal by octet" do
        expect{ subject.process_value(localhost) }.to output("0177.00.00.01\n").to_stdout
      end
    end

    context "when --hex-octet option is given" do
      before { subject.options[:hex_octet] = true }

      it "will convert an IPv4 address to hex by octet" do
        expect{ subject.process_value(localhost) }.to output("7f.0.0.1\n").to_stdout
      end
    end

    context "when --ipv6-compat option is given" do
      before { subject.options[:ipv6_compat] = true }

      it "will convert an IPv4 address to an IPv6 compatible address" do
        expect{ subject.process_value(localhost) }.to output("::ffff:127.0.0.1\n").to_stdout
      end
    end

  end

  describe "#format_ip" do
    let(:ip) { Ronin::Support::Network::IP.new(localhost) }

    context "when options[:hex] is present" do
      before { subject.options[:hex] = true }

      it "will convert an IPv4 address to hexadecimal" do
        expect(subject.format_ip(ip)).to eq("0x7f000001")
      end
    end

    context "when options[:decimal] is present" do
      before { subject.options[:decimal] = true }

      it "will convert an IPv4 address to decimal" do
        expect(subject.format_ip(ip)).to eq("2130706433")
      end
    end

    context "when options[:octal] is present" do
      before { subject.options[:octal] = true }
      
      it "will convert an IPv4 address to octal" do
        expect(subject.format_ip(ip)).to eq("017700000001")
      end
    end

    context "when options[:binary] is present" do
      before { subject.options[:binary] = true }

      it "will convert an IPv4 address to binary" do
        expect(subject.format_ip(ip)).to eq("1111111000000000000000000000001")
      end
    end

    context "when options[:octal_octet] is present" do
      before { subject.options[:octal_octet] = true }

      it "will convert an IPv4 address to octal by octet" do
        expect(subject.format_ip(ip)).to eq("0177.00.00.01")
      end
    end

    context "when options[:hex_octet] is present" do
      before { subject.options[:hex_octet] = true }

      it "will convert an IPv4 address to hex by octet" do
        expect(subject.format_ip(ip)).to eq("7f.0.0.1")
      end
    end

    context "when options[:ipv6_compat] is present" do
      before { subject.options[:ipv6_compat] = true }

      it "will convert an IPv4 address to an IPv6 compatible address" do
        expect(subject.format_ip(ip)).to eq("::ffff:127.0.0.1")
      end
    end

  end
end
