require 'ronin/extensions/ip_addr'

require 'spec_helper'

describe IPAddr do
  describe "CIDR addresses" do
    before(:all) do
      @fixed_addr = IPAddr.new('10.1.1.2')
      @class_c = IPAddr.new('10.1.1.2/24')
    end

    it "should only iterate over one IP address for an address" do
      addresses = @fixed_addr.map { |ip| IPAddr.new(ip) }

      addresses.length.should == 1
      @fixed_addr.include?(addresses.first)
    end

    it "should iterate over all IP addresses contained within the IP range" do
      @class_c.each do |ip|
        @class_c.include?(IPAddr.new(ip)).should == true
      end
    end
  end

  describe "globbed addresses" do
    before(:all) do
      @ipv4_range = '10.1.1-5.1'
      @ipv6_range = '::ff::02-0a::c3'
    end

    it "should iterate over all IP addresses in an IPv4 range" do
      IPAddr.each(@ipv4_range) do |ip|
        ip =~ /^10\.1\.[1-5]\.1$/
      end
    end

    it "should iterate over all IP addresses in an IPv6 range" do
      IPAddr.each(@ipv6_range) do |ip|
        ip =~ /^::ff::0[2-9a]::c3$/
      end
    end
  end
end
