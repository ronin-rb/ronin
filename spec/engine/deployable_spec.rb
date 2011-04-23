require 'spec_helper'
require 'engine/classes/deployable_class'

describe Engine::Deployable do
  subject do
    obj = DeployableClass.new
    obj.instance_eval do
      test do
        unless @var > 0
          raise "engine failed verification"
        end
      end
    end

    obj
  end

  it "should include Testable" do
    subject.class.included_modules.should include(Engine::Testable)
  end

  it "should not be deployed by default" do
    subject.should_not be_deployed
  end

  describe "#deploy!" do
    it "should test! the engine before deploying it" do
      subject.var = -1

      lambda {
        subject.deploy!
      }.should raise_error
    end

    it "should mark the engine deployed" do
      subject.deploy!

      subject.should be_deployed
    end

    it "should not mark the engine as evacuated" do
      subject.deploy!

      subject.should_not be_evacuated
    end
  end

  describe "#evacuate!" do
    it "should mark the engine as evacuated" do
      subject.evacuate!

      subject.should be_evacuated
    end
  end
end
