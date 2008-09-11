require 'ronin/product'

require 'spec_helper'

describe Product do
  it "should require name and version attributes" do
    @product = Product.new
    @product.should_not be_valid

    @product.name = 'test'
    @product.should_not be_valid

    @product.version = '0.1.0'
    @product.should be_valid
  end
end
