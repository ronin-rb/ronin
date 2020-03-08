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
    expect(subject).not_to be_built
  end

  it "should include Testable" do
    expect(subject.class.included_modules).to include(Script::Testable)
  end

  describe "#build!" do
    it "should call the build block" do
      subject.build!

      expect(subject.output).to eq("hello world")
    end

    it "should mark the script as built" do
      subject.build!

      expect(subject).to be_built
    end

    it "should accept parameters as options" do
      subject.build!(:var => 'dave')

      expect(subject.output).to eq("hello dave")
      expect(subject.var).to eq('dave')
    end
  end

  describe "#verify!" do
    it "should raise a NotBuilt exception when verifying unbuilt scripts" do
      expect {
        subject.test!
      }.to raise_error(Script::NotBuilt)
    end
  end
end
