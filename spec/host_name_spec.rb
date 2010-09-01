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

  it "should resolv the IP Address for the host name" do
    subject.resolv.address.should == example_ip
  end

  it "should resolv all IP Addresses for the host name" do
    ips = subject.resolv_all.map { |ip| ip.address }
    
    ips.should include(example_ip)
  end
end
