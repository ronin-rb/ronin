require 'spec_helper'
require 'ronin/ip_address'

describe IPAddress do
  let(:example_domain) { 'www.example.com' }
  let(:example_ip) { '192.0.32.10' }

  subject { IPAddress.new(:address => example_ip) }

  it "should require an address" do
    ip = IPAddress.new

    ip.should_not be_valid
  end

  describe "lookup" do
    subject { IPAddress }

    let(:bad_domain) { '.bad.domain.com.' }

    it "should lookup host-names to IP Addresses" do
      ips = subject.lookup(example_domain)

      ips.should_not be_empty
      ips[0].address.should == example_ip
    end

    it "should associate the IP addresses with the original host name" do
      ips = subject.lookup(example_domain)

      ips.each do |ip|
        ip.host_names[0].address.should == example_domain
      end
    end

    it "should return an empty Array for unknown domain names" do
      ips = subject.lookup(bad_domain)
      
      ips.should be_empty
    end
  end

  describe "#lookup!" do
    let(:bad_ip) { '0.0.0.0' }

    it "should reverse lookup the host-name for an IP Address" do
      host_names = subject.lookup!
      
      host_names.should_not be_empty
      host_names[0].address.should == example_domain
    end

    it "should associate the host names with the original IP address" do
      host_names = subject.lookup!

      host_names.each do |host_name|
        host_name.ip_addresses[0].address.should == subject
      end
    end

    it "should return an empty Array for unknown domain names" do
      ip = IPAddress.new(:address => bad_ip)
      host_names = ip.lookup!

      host_names.should be_nil
    end
  end

  describe "#version" do
    let(:ipv4) { IPAddress.new(:address => '192.168.1.1') }
    let(:ipv6) { IPAddress.new(:address => '::1') }

    it "should only accept 4 or 6" do
      ip = IPAddress.new(:address => '1.1.1.1', :version => 7)

      ip.should_not be_valid
    end

    it "should default to the version of the address" do
      ipv4.version.should == 4
      ipv6.version.should == 6
    end
  end
end
