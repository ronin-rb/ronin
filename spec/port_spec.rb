require 'spec_helper'
require 'ronin/port'

describe Port do
  let(:protocol) { 'tcp' }
  let(:number) { 80 }

  before(:all) do
    @port = Port.create(:protocol => protocol, :number => number)
  end

  it "should require a protocol" do
    port = Port.new(:number => 1111)

    port.should_not be_valid
  end

  it "should require a port number" do
    port = Port.new(:protocol => 'tcp')

    port.should_not be_valid
  end

  it "should only allow 'tcp' and 'udp' as protocols" do
    port = Port.new(:protocol => 'foo', :number => 1111)

    port.should_not be_valid
  end

  it "should require unique protocol/port-number combinations" do
    port = Port.new(:protocol => protocol, :number => number)

    port.should_not be_valid
  end

  it "should be convertable to an Integer" do
    @port.to_i.should == number
  end

  it "should be convertable to a String" do
    @port.to_s.should == "#{number}/#{protocol}"
  end
end
