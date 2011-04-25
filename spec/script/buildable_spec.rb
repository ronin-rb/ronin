require 'spec_helper'
require 'ronin/script/buildable'
require 'script/classes/buildable_class'

describe Script::Buildable do
  subject do
    obj = BuildableClass.new
    obj.instance_eval do
      build { @output = "hello #{@var}" }
    end

    obj
  end

  it "should not be built by default" do
    subject.should_not be_built
  end

  it "should include Testable" do
    subject.class.included_modules.should include(Script::Testable)
  end

  describe "#build!" do
    it "should call the build block" do
      subject.build!

      subject.output.should == "hello world"
    end

    it "should mark the script as built" do
      subject.build!

      subject.should be_built
    end

    it "should accept parameters as options" do
      subject.build!(:var => 'dave')

      subject.output.should == "hello dave"
      subject.var.should == 'dave'
    end
  end

  describe "#verify!" do
    it "should raise a NotBuilt exception when verifying unbuilt scripts" do
      lambda {
        subject.test!
      }.should raise_error(Script::NotBuilt)
    end
  end
end
