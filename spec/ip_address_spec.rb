require 'spec_helper'
require 'ronin/ip_address'

describe IPAddress do
  let(:example_domain) { 'localhost' }
  let(:example_ip) { '127.0.0.1' }

  subject { IPAddress.new(:address => example_ip) }

  it "should require an address" do
    ip_address = IPAddress.new

    ip_address.should_not be_valid
  end

  describe "extract" do
    subject { IPAddress }

    let(:ip1)  { subject.parse('127.0.0.1') }
    let(:ip2)  { subject.parse('10.1.1.1') }
    let(:text) { "Hosts: #{ip1}, #{ip2}" }

    it "should extract multiple IP Addresses from text" do
      subject.extract(text).should == [ip1, ip2]
    end

    it "should yield the extracted IPs if a block is given" do
      ip_addresses = []

      subject.extract(text) { |ip| ip_addresses << ip }

      ip_addresses.should == [ip1, ip2]
    end
  end

  describe "lookup" do
    subject { IPAddress }

    let(:bad_domain) { '.bad.domain.com.' }

    it "should lookup host-names to IP Addresses" do
      ip_addresses = subject.lookup(example_domain)
      addresses    = ip_addresses.map { |ip| ip.address }
      
      addresses.should include(example_ip)
    end

    it "should associate the IP addresses with the original host name" do
      ip_addresses = subject.lookup(example_domain)
      host_names   = ip_addresses.map { |ip| ip.host_names[0].address }
      
      host_names.should include(example_domain)
    end

    it "should return an empty Array for unknown domain names" do
      ip_addresses = subject.lookup(bad_domain)
      
      ip_addresses.should be_empty
    end
  end

  describe "#lookup!" do
    let(:bad_ip) { '0.0.0.0' }

    it "should reverse lookup the host-name for an IP Address" do
      host_names = subject.lookup!
      addresses  = host_names.map { |host_name| host_name.address }
      
      addresses.should include(example_domain)
    end

    it "should associate the host names with the original IP address" do
      host_names   = subject.lookup!
      ip_addresses = host_names.map do |host_name|
        host_name.ip_addresses[0].address
      end

      ip_addresses.should include(subject)
    end

    it "should return an empty Array for unknown domain names" do
      ip_address = IPAddress.new(:address => bad_ip)
      host_names = ip_address.lookup!

      host_names.should be_empty
    end
  end

  describe "#version" do
    let(:ipv4) { IPAddress.new(:address => '127.0.0.1') }
    let(:ipv6) { IPAddress.new(:address => '::1') }

    it "should only accept 4 or 6" do
      ip_address = IPAddress.new(:address => '1.1.1.1', :version => 7)

      ip_address.should_not be_valid
    end

    it "should default to the version of the address" do
      ipv4.version.should == 4
      ipv6.version.should == 6
    end
  end
end
