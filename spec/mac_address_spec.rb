require 'spec_helper'
require 'ronin/mac_address'

describe MACAddress do
  let(:address) { '00:01:02:03:04:05' }

  subject { MACAddress.new(:address => address) }

  describe "extract" do
    subject { described_class }

    let(:mac1) { subject.parse('00:12:34:56:78:9a') }
    let(:mac2) { subject.parse('AA:BB:CC:DD:EE:FF') }
    let(:text)  { "MACs: #{mac1}, #{mac2}." }

    it "should extract multiple MAC Addresses from text" do
      subject.extract(text).should == [mac1, mac2]
    end

    it "should yield the extracted MAC Addresses if a block is given" do
      macs = []

      subject.extract(text) { |mac| macs << mac }

      macs.should == [mac1, mac2]
    end
  end

  it "should require an address" do
    mac = MACAddress.new

    mac.should_not be_valid
  end

  it "should convert the MAC Address to an Integer" do
    subject.to_i.should == 0x000102030405
  end
end
