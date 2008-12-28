require 'ronin/objectify'

require 'spec_helper'

describe Objectify do
  before(:all) do
    class TestObject

      include Objectify

      objectify :test

      property :mesg, String

      parameter :x

      parameter :y

    end
  end

  it "should create an object with a Hash of attributes and params" do
    test = TestObject.new(:mesg => 'hello', :x => 3, :y => 9)

    test.mesg.should == 'hello'
    test.x.should == 3
    test.y.should == 9
  end
end
