require 'spec_helper'
require 'ronin/ronin'
require 'ronin/version'

describe Ronin do
  it "should have a version" do
    version = subject.const_get('VERSION')

    version.should_not be_nil
    version.should_not be_empty
  end

  it "should include AutoLoad" do
    subject.should include(AutoLoad)
  end

  it "should add a const_missing method when included" do
    base_class = Class.new
    base_class.send :include, subject

    subject.const_set('SOME_CONSTANT',1)

    base_class.const_get('SOME_CONSTANT').should == 1
  end
end
