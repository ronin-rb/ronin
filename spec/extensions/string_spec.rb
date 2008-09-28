require 'ronin/extensions/string'

require 'spec_helper'

describe String do
  it "should be able to convert proper names to method names" do
    "Proper Name".to_method_name.should == 'proper_name'
  end

  it "should be able to convert Class names to method names" do
    "Namespace::Test".to_method_name.should == 'namespace_test'
  end
end
