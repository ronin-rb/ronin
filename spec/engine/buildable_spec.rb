require 'spec_helper'
require 'ronin/engine/buildable'
require 'engine/classes/buildable_class'

describe Engine::Buildable do
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

  describe "build!" do
    it "should call the build block" do
      subject.build!

      subject.output.should == "hello world"
    end

    it "should make the object as built" do
      subject.build!

      subject.should be_built
    end

    it "should accept parameters as options" do
      subject.build!(:var => 'dave')

      subject.output.should == "hello dave"
      subject.var.should == 'dave'
    end
  end
end
