require 'spec_helper'
require 'ronin/engine/testable'
require 'engine/classes/testable_class'

describe Engine::Testable do
  subject { TestableClass }

  it "should allow for custom verifications" do
    obj = subject.new do
      test do
        flunk('var must be greater than 2') unless self.var > 2
      end

      test do
        flunk('var must be less than 10') unless self.var < 10
      end
    end

    obj.var = 20
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 4
    obj.test!.should == true
  end

  it "should test an expression is true" do
    obj = subject.new do
      test? 'var + 2 must equal 4' do
        (self.var + 2) == 4
      end
    end

    obj.var = 1
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 2
    obj.test!.should == true
  end

  it "should test a method returns an expected value" do
    obj = subject.new { test_equal :var, 5 }

    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 5
    obj.test!.should == true
  end

  it "should test a method does not return an expected value" do
    obj = subject.new { test_not_equal :var, 5 }

    obj.var = 5
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 2
    obj.test!.should == true
  end

  it "should test a method returns a non-nil value" do
    obj = subject.new { test_set :var }

    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 2
    obj.test!.should == true
  end

  it "should test a method returns a non-empty value" do
    obj = subject.new { test_set :var }

    obj.var = ''
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 'hello'
    obj.test!.should == true
  end

  it "should test a method matches a pattern" do
    obj = subject.new { test_match :var, /lo/ }

    obj.var = 'goodbye'
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 'hello'
    obj.test!.should == true
  end

  it "should test a method does not match a pattern" do
    obj = subject.new { test_no_match :var, /lo/ }

    obj.var = 'hello'
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 'goodbye'
    obj.test!.should == true
  end

  it "should test a method returns a value in a set of values" do
    obj = subject.new { test_in :var, [0, 2, 4, 8] }

    obj.var = 3
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 2
    obj.test!.should == true
  end

  it "should test a method returns a value not in a set of values" do
    obj = subject.new { test_not_in :var, [0, 2, 4, 8] }

    obj.var = 2
    lambda { obj.test! }.should raise_error(Engine::TestFailed)

    obj.var = 3
    obj.test!.should == true
  end
end
