require 'ronin/platform/extension'

require 'spec_helper'
require 'platform/helpers/extensions'

describe Platform::Extension do
  include Helpers::Extensions

  before(:each) do
    @ext = Platform::Extension.new('test')
    @ext.include_path(extension_path('test'))
  end

  it "should not allow including bad paths" do
    lambda {
      @ext.include_path('bla')
    }.should raise_error(RuntimeError)
  end

  it "should not include the same path twice" do
    @ext.include_path(extension_path('test')).should == false
  end

  it "should prevent circular including of paths" do
    @ext.include_path(extension_path('circular'))

    @ext.paths.select { |path|
      File.basename(path) == 'circular.rb'
    }.length.should == 1
  end

  it "should allow defining reader methods for instance variables" do
    @ext.instance_variable_set('@var',2)

    @ext.var.should == 2
  end

  it "should allow defining writer methods for instance variables" do
    @ext.var = 3

    @ext.instance_variable_get('@var').should == 3
  end

  it "should specify which methods were added to the extension" do
    @ext.exposed_methods.should == [:test_method, :var, :var=]
  end

  it "should allow calling added methods" do
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
    @ext.var.should == :toredown
  end

  it "should not be torendown before it is setup" do
    @ext.teardown!
    @ext.var.should be_nil
  end

  it "should allow the definition of reader and writer methods" do
    @ext.setup!
    
    @ext.var.should == :setup
    @ext.var = :random
    @ext.var.should == :random
  end
end
