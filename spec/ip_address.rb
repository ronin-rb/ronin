require 'spec_helper'
require 'ronin/ip_address'

describe IPAddress do
  let(:example_domain) { 'www.example.com' }
  let(:example_ip) { '192.0.32.10' }

  it "should require an address" do
    ip = IPAddress.new

    ip.should_not be_valid
  end

  describe "dns" do
    subject { IPAddress }

    let(:bad_domain) { '.bad.domain.com.' }

    it "should resolve host-names to IP Addresses" do
      ips = IPAddress.dns(example_domain)

      ips.should_not be_empty
      ips[0].address.should == example_ip
    end

    it "should return an empty Array for unresolved domain names" do
      ips = subject.dns(bad_domain)
      
      ips.should be_empty
    end
  end

  describe "#dns!" do
    let(:bad_ip) { '0.0.0.0' }

    it "should reverse lookup the host-name for an IP Address" do
      ip = IPAddress.new(:address => example_ip)
      host_names = ip.dns!
      
      host_names.should_not be_empty
      host_names[0].address.should == example_domain
    end

    it "should return an empty Array for unresolved domain names" do
      ip = IPAddress.new(:address => bad_ip)
      host_names = ip.dns!

      host_names.should be_nil
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
