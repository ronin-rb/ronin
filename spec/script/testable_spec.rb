require 'spec_helper'
require 'ronin/script/testable'
require 'script/classes/testable_class'

describe Script::Testable do
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
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 4
    expect(obj.test!).to be(true)
  end

  it "should test an expression is true" do
    obj = subject.new do
      test? 'var + 2 must equal 4' do
        (self.var + 2) == 4
      end
    end

    obj.var = 1
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 2
    expect(obj.test!).to be(true)
  end

  it "should test a method returns an expected value" do
    obj = subject.new { test_equal :var, 5 }

    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 5
    expect(obj.test!).to be(true)
  end

  it "should test a method does not return an expected value" do
    obj = subject.new { test_not_equal :var, 5 }

    obj.var = 5
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 2
    expect(obj.test!).to be(true)
  end

  it "should test a method returns a non-nil value" do
    obj = subject.new { test_set :var }

    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 2
    expect(obj.test!).to be(true)
  end

  it "should test a method returns a non-empty value" do
    obj = subject.new { test_set :var }

    obj.var = ''
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 'hello'
    expect(obj.test!).to be(true)
  end

  it "should test a method matches a pattern" do
    obj = subject.new { test_match :var, /lo/ }

    obj.var = 'goodbye'
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 'hello'
    expect(obj.test!).to be(true)
  end

  it "should test a method does not match a pattern" do
    obj = subject.new { test_no_match :var, /lo/ }

    obj.var = 'hello'
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 'goodbye'
    expect(obj.test!).to be(true)
  end

  it "should test a method returns a value in a set of values" do
    obj = subject.new { test_in :var, [0, 2, 4, 8] }

    obj.var = 3
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 2
    expect(obj.test!).to be(true)
  end

  it "should test a method returns a value not in a set of values" do
    obj = subject.new { test_not_in :var, [0, 2, 4, 8] }

    obj.var = 2
    expect { obj.test! }.to raise_error(Script::TestFailed)

    obj.var = 3
    expect(obj.test!).to be(true)
  end
end
