require 'ronin/objectify'

require 'spec_helper'
require 'objectify/classes/test_object'

describe Objectify do
  it "should create an object with a Hash of attributes and params" do
    test = TestObject.new(:mesg => 'hello', :x => 3, :y => 9)

    test.mesg.should == 'hello'
    test.x.should == 3
    test.y.should == 9
  end
end
