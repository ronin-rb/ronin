require 'spec_helper'
require 'ronin/host_name'

describe HostName do
  let(:example_domain) { 'www.example.com' }
  let(:example_ip) { '192.0.32.10' }
  let(:bad_domain) { '.bad.domain.com.' }

  subject { HostName.new(:address => example_domain) }

  it "should require an address" do
    host_name = HostName.new

    host_name.should_not be_valid
  end

  describe "resolv" do
    it "should resolv the IP Address for the host name" do
      subject.resolv.address.should == example_ip
    end

    it "should return nil for unresolved host names" do
      HostName.new(:address => bad_domain).resolv.should be_nil
    end
  end

  describe "resolv_all" do
    it "should resolv all IP Addresses for the host name" do
      ips = subject.resolv_all.map { |ip| ip.address }
    
      ips.should include(example_ip)
    end

    it "should return an empty Array for unresolved host names" do
      HostName.new(:address => bad_domain).resolv_all.should be_empty
    end
  end
end
