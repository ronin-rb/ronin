require 'spec_helper'
require 'ronin/cli/commands/ip'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Ip do
  include_examples "man_page"

  let(:ipcmd) { Ronin::CLI::Commands::Ip.new}
  let(:localhost) { "127.0.0.1" }

  describe "-r" do
    it "will reverse an IPv4 address" do
      ipcmd.options[:reverse] = true
      expect{ ipcmd.process_value(localhost) }.to output("1.0.0.127.in-addr.arpa\n").to_stdout
    end
  end

  describe "--hex" do
    it "will convert an IPv4 address to hexadecimal" do
      ipcmd.options[:hex] = true
      expect{ ipcmd.process_value(localhost) }.to output("0x7f000001\n").to_stdout
    end
  end

  describe "--decimal" do
    it "will convert an IPv4 address to decimal" do
      ipcmd.options[:decimal] = true
      expect{ ipcmd.process_value(localhost) }.to output("2130706433\n").to_stdout
    end
  end

  describe "--octal" do
    it "will convert an IPv4 address to octal" do
      ipcmd.options[:octal] = true
      expect{ ipcmd.process_value(localhost) }.to output("017700000001\n").to_stdout
    end
  end

  describe "--binary" do
    it "will convert an IPv4 address to binary" do
      ipcmd.options[:binary] = true
      expect{ ipcmd.process_value(localhost) }.to output("1111111000000000000000000000001\n").to_stdout
    end
  end

  describe "--octal-octet" do
    it "will convert an IPv4 address to octal by octet" do
      ipcmd.options[:octal_octet] = true
      expect{ ipcmd.process_value(localhost) }.to output("0177.00.00.01\n").to_stdout
    end
  end

  describe "--hex-octet" do
    it "will convert an IPv4 address to hex by octet" do
      ipcmd.options[:hex_octet] = true
      expect{ ipcmd.process_value(localhost) }.to output("7f.0.0.1\n").to_stdout
    end
  end

  describe "--ipv6-compat" do
    it "will convert an IPv4 address to an IPv6 compatible address" do
      ipcmd.options[:ipv6_compat] = true
      expect{ ipcmd.process_value(localhost) }.to output("::ffff:127.0.0.1\n").to_stdout
    end
  end
end
