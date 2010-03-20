require 'ronin/product'

require 'helpers/database'

describe Product do
  it "should require name and version attributes" do
    product = Product.new
    product.should_not be_valid

    product.name = 'Test'
    product.should_not be_valid

    product.version = '0.1.0'
    product.should be_valid
  end

  it "should be convertable to a String" do
    product = Product.new(:name => 'Test', :version => '0.1.0')
    product.to_s.should == 'Test 0.1.0'

    product.vendor = Vendor.new(:name => 'TestCo')
    product.to_s.should == 'TestCo Test 0.1.0'
  end
end
