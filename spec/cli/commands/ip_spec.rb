require 'spec_helper'
require 'ronin/cli/commands/ip'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Ip do
  include_examples "man_page"

  let(:localhost) { "127.0.0.1" }

  describe "#process_value" do
    describe "when -r option is given" do
      it "will reverse an IPv4 address" do
        subject.options[:reverse] = true
        expect{ subject.process_value(localhost) }.to output("1.0.0.127.in-addr.arpa\n").to_stdout
      end
    end

    describe "when --hex option is given" do
      it "will convert an IPv4 address to hexadecimal" do
        subject.options[:hex] = true
        expect{ subject.process_value(localhost) }.to output("0x7f000001\n").to_stdout
      end
    end

    describe "when --decimal option is given" do
      it "will convert an IPv4 address to decimal" do
        subject.options[:decimal] = true
        expect{ subject.process_value(localhost) }.to output("2130706433\n").to_stdout
      end
    end

    describe "when --octal option is given" do
      it "will convert an IPv4 address to octal" do
        subject.options[:octal] = true
        expect{ subject.process_value(localhost) }.to output("017700000001\n").to_stdout
      end
    end

    describe "when --binary option is given" do
      it "will convert an IPv4 address to binary" do
        subject.options[:binary] = true
        expect{ subject.process_value(localhost) }.to output("1111111000000000000000000000001\n").to_stdout
      end
    end

    describe "when --octal-octet option is given" do
      it "will convert an IPv4 address to octal by octet" do
        subject.options[:octal_octet] = true
        expect{ subject.process_value(localhost) }.to output("0177.00.00.01\n").to_stdout
      end
    end

    describe "when --hex-octet option is given" do
      it "will convert an IPv4 address to hex by octet" do
        subject.options[:hex_octet] = true
        expect{ subject.process_value(localhost) }.to output("7f.0.0.1\n").to_stdout
      end
    end

    describe "when --ipv6-compat option is given" do
      it "will convert an IPv4 address to an IPv6 compatible address" do
        subject.options[:ipv6_compat] = true
        expect{ subject.process_value(localhost) }.to output("::ffff:127.0.0.1\n").to_stdout
      end
    end

  end

  describe "#format_ip" do
    describe "when options[:hex] is present" do
      it "will convert an IPv4 address to hexadecimal" do
        subject.options[:hex] = true
        expect(subject.format_ip(localhost)).to eq("0x7f")
      end
    end

    describe "when options[:decimal] is present" do
      it "will convert an IPv4 address to decimal" do
        subject.options[:decimal] = true
        expect(subject.format_ip(localhost)).to eq("127")
      end
    end

    describe "when options[:octal] is present" do
      it "will convert an IPv4 address to octal" do
        subject.options[:octal] = true
        expect(subject.format_ip(localhost)).to eq("0177")
      end
    end

    describe "when options[:binary] is present" do
      it "will convert an IPv4 address to binary" do
        subject.options[:binary] = true
        expect(subject.format_ip(localhost)).to eq("1111111")
      end
    end

    describe "when options[:octal_octet] is present" do
      it "will convert an IPv4 address to octal by octet" do
        subject.options[:octal_octet] = true
        expect(subject.format_ip(localhost)).to eq("0177.00.00.01")
      end
    end

    describe "when options[:hex_octet] is present" do
      it "will convert an IPv4 address to hex by octet" do
        subject.options[:hex_octet] = true
        expect(subject.format_ip(localhost)).to eq("7f.0.0.1")
      end
    end

    describe "when options[:ipv6_compat] is present" do
      it "will convert an IPv4 address to an IPv6 compatible address" do
        subject.options[:ipv6_compat] = true
        expect(subject.format_ip(localhost)).to eq("::ffff:127.0.0.1")
      end
    end

  end
end
