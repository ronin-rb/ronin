require 'spec_helper'
require 'ronin/ip_address'

describe IPAddress do
  it "should require an address" do
    ip = IPAddress.new

    ip.should_not be_valid
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
