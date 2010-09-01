require 'spec_helper'
require 'ronin/ip_address'

describe IPAddress do
  let(:example_domain) { 'www.example.com' }
  let(:example_ip) { '192.0.32.10' }

  it "should require an address" do
    ip = IPAddress.new

    ip.should_not be_valid
  end

  it "should resolve host names to IP Addresses" do
    ip = IPAddress.resolv(example_domain)

    ip.address.should == example_ip
  end

  it "should resolve host names to multiple IP Addresses" do
    ips = IPAddress.resolv_all(example_domain).map { |ip| ip.address }

    ips.should include(example_ip)
  end

  it "should reverse lookup any host names for the IP Address" do
    ip = IPAddress.new(:address => example_ip)

    ip.reverse_lookup.address.should == example_domain
  end

  describe "version" do
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
