require 'spec_helper'
require 'ronin/mac_address'

describe MACAddress do
  let(:address) { '00:01:02:03:04:05' }

  subject { MACAddress.new(:address => address) }

  it "should require an address" do
    mac = MACAddress.new

    mac.should_not be_valid
  end

  it "should convert the MAC Address to an Integer" do
    subject.to_i.should == 0x000102030405
  end
end
