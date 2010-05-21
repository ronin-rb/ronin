require 'spec_helper'

require 'ronin/vendor'

describe Vendor do
  it "should require name attribute" do
    product = Vendor.new
    product.should_not be_valid

    product.name = 'TestCo'
    product.should be_valid
  end

  it "should be convertable to a String" do
    vendor = Vendor.new(:name => 'TestCo')
    vendor.to_s.should == 'TestCo'
  end
end
