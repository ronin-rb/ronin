require 'spec_helper'
require 'script/classes/deployable_class'

describe Script::Deployable do
  subject do
    obj = DeployableClass.new
    obj.instance_eval do
      test do
        unless @var > 0
          raise "script failed verification"
        end
      end
    end

    obj
  end

  it "should include Testable" do
    expect(subject.class.included_modules).to include(Script::Testable)
  end

  it "should not be deployed by default" do
    expect(subject).not_to be_deployed
  end

  describe "#deploy!" do
    it "should test! the script before deploying it" do
      subject.var = -1

      expect {
        subject.deploy!
      }.to raise_error
    end

    it "should mark the script deployed" do
      subject.deploy!

      expect(subject).to be_deployed
    end

    it "should not mark the script as evacuated" do
      subject.deploy!

      expect(subject).not_to be_evacuated
    end
  end

  describe "#evacuate!" do
    it "should mark the script as evacuated" do
      subject.evacuate!

      expect(subject).to be_evacuated
    end
  end
end
