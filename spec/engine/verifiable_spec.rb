require 'spec_helper'
require 'ronin/engine/verifiable'
require 'engine/classes/verifiable_class'

describe Engine::Verifiable do
  subject { VerifiableClass }

  it "should allow for custom verifications" do
    obj = subject.new do
      verify do
        flunk('var must be greater than 2') unless self.var > 2
      end

      verify do
        flunk('var must be less than 10') unless self.var < 10
      end
    end

    obj.var = 20
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 4
    obj.verify!.should == true
  end

  it "should verify an expression is true" do
    obj = subject.new do
      verify? 'var + 2 must equal 4' do
        (self.var + 2) == 4
      end
    end

    obj.var = 1
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 2
    obj.verify!.should == true
  end

  it "should verify a method returns an expected value" do
    obj = subject.new { verify_equal :var, 5 }

    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 5
    obj.verify!.should == true
  end

  it "should verify a method does not return an expected value" do
    obj = subject.new { verify_not_equal :var, 5 }

    obj.var = 5
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 2
    obj.verify!.should == true
  end

  it "should verify a method returns a non-nil value" do
    obj = subject.new { verify_set :var }

    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 2
    obj.verify!.should == true
  end

  it "should verify a method returns a non-empty value" do
    obj = subject.new { verify_set :var }

    obj.var = ''
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 'hello'
    obj.verify!.should == true
  end

  it "should verify a method matches a pattern" do
    obj = subject.new { verify_match :var, /lo/ }

    obj.var = 'goodbye'
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 'hello'
    obj.verify!.should == true
  end

  it "should verify a method does not match a pattern" do
    obj = subject.new { verify_no_match :var, /lo/ }

    obj.var = 'hello'
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 'goodbye'
    obj.verify!.should == true
  end

  it "should verify a method returns a value in a set of values" do
    obj = subject.new { verify_in :var, [0, 2, 4, 8] }

    obj.var = 3
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 2
    obj.verify!.should == true
  end

  it "should verify a method returns a value not in a set of values" do
    obj = subject.new { verify_not_in :var, [0, 2, 4, 8] }

    obj.var = 2
    lambda { obj.verify! }.should raise_error(Engine::VerificationFailed)

    obj.var = 3
    obj.verify!.should == true
  end
end
