require 'spec_helper'
require 'platform/spec_helper'
require 'platform/helpers/extensions'

require 'ronin/platform/extension'

describe Platform::Extension do
  include Helpers::Extensions

  subject { Platform::Extension.new('test') }

  before(:all) do
    subject.include_path(extension_path('test'))
  end

  it "should not allow including bad paths" do
    lambda {
      subject.include_path('bla')
    }.should raise_error(RuntimeError)
  end

  it "should not include the same path twice" do
    subject.include_path(extension_path('test')).should == false
  end

  it "should prevent circular including of paths" do
    subject.include_path(extension_path('circular'))

    subject.paths.select { |path|
      File.basename(path) == 'circular.rb'
    }.length.should == 1
  end

  it "should allow defining reader methods for instance variables" do
    subject.instance_variable_set('@var',2)

    subject.var.should == 2
  end

  it "should allow defining writer methods for instance variables" do
    subject.var = 3

    subject.instance_variable_get('@var').should == 3
  end

  it "should specify which methods were added to the extension" do
    subject.exposed_methods.should == [:test_method, :var, :var=]
  end

  it "should allow calling added methods" do
    subject.test_method.should == :method
  end

  it "should have a setup state" do
    subject.setup!
    subject.should be_setup
  end

  it "should have setup blocks" do
    subject.setup!
    subject.instance_eval { @var }.should == :setup
  end

  it "should have a toredown state" do
    subject.teardown!

    subject.should be_toredown
  end

  it "should have teardown blocks" do
    subject.setup!
    subject.teardown!

    subject.var.should == :toredown
  end

  it "should not be torendown before it is setup" do
    subject.teardown!

    subject.var.should be_nil
  end

  it "should allow the definition of reader and writer methods" do
    subject.setup!
    
    subject.var.should == :setup
    subject.var = :random
    subject.var.should == :random
  end
end
