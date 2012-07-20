require 'spec_helper'

require 'ronin/host_name'

describe HostName do
  let(:domain) { 'localhost' }
  let(:ip) { '127.0.0.1' }

  subject { described_class.new(:address => domain) }

  describe "validations" do
    it "should require an address" do
      host_name = described_class.new

      host_name.should_not be_valid
    end
  end

  it "should alias #name to #address" do
    subject.name.should == subject.address
  end

  describe "extract" do
    subject { described_class }

    let(:host1) { subject.parse('www.example.com') }
    let(:host2) { subject.parse('1.2.3.4.in-addr.arpa') }
    let(:text)  { "Hosts: #{host1}, #{host2}." }

    it "should extract multiple host-names from text" do
      subject.extract(text).should == [host1, host2]
    end

    it "should yield the extracted host-names if a block is given" do
      hosts = []

      subject.extract(text) { |host| hosts << host }

      hosts.should == [host1, host2]
    end
  end

  describe "lookup" do
    subject { described_class }

    let(:bad_ip) { '0.0.0.0' }

    it "should look up the host names for an IP Address" do
      host_names = subject.lookup(ip).map { |name| name.address }
      
      host_names.should include(domain)
    end

    it "should associate the host names with the original IP address" do
      host_names = subject.lookup(ip)
      
      host_names.each do |host|
        host.ip_addresses[0].address.should == ip
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
      ips[0].address.should == ip
    end

    it "should associate the IP addresses with the original host name" do
      ips = subject.lookup!
      
      ips.each do |ip|
        ip.host_names[0].address.should == domain
      end
    end

    it "should return an empty Array for unknown host names" do
      ips = described_class.new(:address => bad_domain).lookup!
      
      ips.should be_empty
    end
  end
end
