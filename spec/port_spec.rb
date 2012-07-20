require 'spec_helper'

require 'ronin/port'

describe Port do
  let(:protocol) { 'tcp' }
  let(:number)   { 80    }

  subject do
    described_class.new(:protocol => protocol, :number => number)
  end

  before { subject.save }

  describe "validations" do
    it "should require a protocol" do
      port = described_class.new(:number => port)

      port.should_not be_valid
    end

    it "should require a port number" do
      port = described_class.new(:protocol => protocol)

      port.should_not be_valid
    end

    it "should only allow 'tcp' and 'udp' as protocols" do
      port = described_class.new(:protocol => 'foo', :number => port)

      port.should_not be_valid
    end

    it "should require unique protocol/port-number combinations" do
      port = described_class.new(:protocol => protocol, :number => number)
      port.should_not be_valid
    end
  end

  describe "#to_i" do
    it "should be convertable to an Integer" do
      subject.to_i.should == number
    end
  end

  describe "#to_s" do
    it "should include the number and protocol" do
      subject.to_s.should == "#{number}/#{protocol}"
    end
  end
end
