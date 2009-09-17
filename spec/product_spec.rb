require 'ronin/product'

require 'helpers/database'

describe Product do
  it "should require name and version attributes" do
    product = Product.new
    product.should_not be_valid

    product.name = 'test'
    product.should_not be_valid

    product.version = '0.1.0'
    product.should be_valid
  end

  it "should default the vendor to the name of the product" do
    product = Product.new(:name => 'Adobe', :version => '0.1.0')
    product.vendor.should == product.name

    product.should be_valid
  end
end
