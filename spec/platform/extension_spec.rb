require 'ronin/platform/extension'

require 'spec_helper'
require 'platform/helpers/extensions'

describe Platform::Extension do
  before(:each) do
    @ext = Platform::Extension.new('test')
    @ext.include_path(extension_path('test'))
  end

  it "should allow for custom methods" do
    @ext.has_method?(:test_method).should == true
    @ext.test_method.should == :method
  end

  it "should have a setup state" do
    @ext.setup!
    @ext.should be_setup
  end

  it "should have setup blocks" do
    @ext.setup!
    @ext.instance_eval { @var }.should == :setup
  end

  it "should have a toredown state" do
    @ext.teardown!
    @ext.should be_toredown
  end

  it "should have teardown blocks" do
    @ext.setup!
    @ext.teardown!
    @ext.instance_eval { @var }.should == :toredown
  end

  it "should not be torendown before it is setup" do
    @ext.teardown!
    @ext.instance_eval { @var }.should be_nil
  end

  it "should allow the definition of reader and writer methods" do
    @ext.setup!
    
    @ext.var.should == :setup
    @ext.var = :random
    @ext.var.should == :random
  end
end
