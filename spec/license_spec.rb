require 'spec_helper'

require 'ronin/license'

describe License do
  describe "validations" do
    it "should require name and description attributes" do
      subject.should_not be_valid

      subject.name = 'joke'
      subject.should_not be_valid

      subject.description = "yep, it's a joke."
      subject.should be_valid
    end
  end

  describe "predefined licenses" do
    subject { described_class }

    it "should provide built-in licenses"do
      subject.cc_by.should_not be_nil
    end
  end
end
