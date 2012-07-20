require 'spec_helper'

require 'ronin/os'

describe OS do
  let(:name)    { 'Linux'  }
  let(:version) { '2.6.11' }

  subject { described_class.new(:name => name, :version => version) }

  describe "predefine" do
    it "should provide methods for built-in described_classes" do
      os = described_class.linux

      os.name.should == 'Linux'
    end

    it "should provide methods for creating described_classes with versions" do
      os = described_class.linux(version)

      os.version.should == version
    end
  end

  describe "validations" do
    it "should require a name" do
      os = described_class.new
      os.should_not be_valid

      os.name = 'test'
      os.should be_valid
    end
  end

  describe "#to_s" do
    it "should convert both the name and version" do
      subject.to_s.should == "#{name} #{version}"
    end

    context "without a version" do
      subject { described_class.new(:name => name) }

      it "should convert just the name if there is no version" do
        subject.to_s.should == name
      end
    end
  end
end
