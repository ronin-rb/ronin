require 'spec_helper'
require 'ronin/ip_address'

describe IPAddress do
  let(:example_domain) { 'www.example.com' }
  let(:example_ip) { '192.0.32.10' }
  let(:bad_domain) { '.bad.domain.com.' }
  let(:bad_ip) { '0.0.0.0' }

  it "should require an address" do
    ip = IPAddress.new

    ip.should_not be_valid
  end

  describe "IPAddress.resolv" do
    it "should resolve host names to IP Addresses" do
      ip = IPAddress.resolv(example_domain)

      ip.address.should == example_ip
    end

    it "should return nil for unresolved domain names" do
      IPAddress.resolv(bad_domain).should be_nil
    end
  end

  describe "IPAddress.resolv_all" do
    it "should resolve host names to multiple IP Addresses" do
      ips = IPAddress.resolv_all(example_domain).map { |ip| ip.address }

      ips.should include(example_ip)
    end

    it "should return an empty Array for unresolved domain names" do
      IPAddress.resolv_all(bad_domain).should be_empty
    end
  end

  describe "resolv" do
    it "should reverse lookup the host-name for an IP Address" do
      ip = IPAddress.new(:address => example_ip)

      ip.resolv.address.should == example_domain
    end

    it "should return nil for unresolved domain names" do
      ip = IPAddress.new(:address => bad_ip)
      
      ip.resolv.should be_nil
    end
  end

  describe "resolv_all" do
    it "should reverse lookup the host-names for an IP Address" do
      ip = IPAddress.new(:address => example_ip)

      ip.resolv_all.any? { |host_name|
        host_name.address == example_domain
      }.should == true
    end

    it "should return an empty Array for unresolved domain names" do
      ip = IPAddress.new(:address => bad_ip)

      ip.resolv_all(bad_domain).should be_empty
    end
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
