require 'spec_helper'
require 'ronin/host_name'

describe HostName do
  let(:example_domain) { 'www.example.com' }
  let(:example_ip) { '192.0.32.10' }

  subject { HostName.new(:address => example_domain) }

  it "should require an address" do
    host_name = HostName.new

    host_name.should_not be_valid
  end

  describe "lookup" do
    subject { HostName }

    let(:bad_ip) { '0.0.0.0' }

    it "should look up the host names for an IP Address" do
      host_names = subject.lookup(example_ip)
      
      host_names.should_not be_empty
      host_names[0].address.should == example_domain
    end

    it "should associate the host names with the original IP address" do
      host_names = subject.lookup(example_ip)
      
      host_names.each do |host|
        host.ip_addresses[0].address.should == example_ip
      end
    end

    it "should return an empty Array for unknown host names" do
      host_names = subject.lookup(bad_ip)
      
      host_names.should be_empty
    end
  end

  describe "#lookup!" do
    let(:bad_domain) { '.bad.domain.com.' }

    it "should look up the IP Addresses for the host name" do
      ips = subject.lookup!
      
      ips.should_not be_empty
      ips[0].address.should == example_ip
    end

    it "should associate the IP addresses with the original host name" do
      ips = subject.lookup!
      
      ips.each do |ip|
        ip.host_names[0].address.should == example_domain
      end
    end

    it "should return an empty Array for unknown host names" do
      ips = HostName.new(:address => bad_domain).lookup!
      
      ips.should be_empty
    end
  end
end
