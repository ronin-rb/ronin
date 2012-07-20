require 'spec_helper'

require 'ronin/vendor'

describe Vendor do
  let(:name) { 'TestCo' }

  subject { described_class.new(:name => name) }

  describe "validations" do
    it "should require name attribute" do
      product = described_class.new
      product.should_not be_valid

      product.name = name
      product.should be_valid
    end
  end

  describe "#to_s" do
    it "should include the vendor name" do
      subject.to_s.should == name
    end
  end
end
