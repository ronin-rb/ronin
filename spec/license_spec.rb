require 'spec_helper'

require 'ronin/license'

describe License do
  describe "validations" do
    it "should require name and description attributes" do
      expect(subject).not_to be_valid

      subject.name = 'joke'
      expect(subject).not_to be_valid

      subject.description = "yep, it's a joke."
      expect(subject).to be_valid
    end
  end

  describe "predefined licenses" do
    subject { described_class }

    it "should provide built-in licenses"do
      expect(subject.cc_by).not_to be_nil
    end
  end
end
