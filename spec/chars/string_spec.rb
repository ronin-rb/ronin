require 'ronin/chars/extensions/string'

require 'spec_helper'

describe String do
  before(:all) do
    @alphabet = ['a', 'b', 'c', 'd']
  end

  it "should be able to test if the string belongs to an alphabet" do
    "abcba".in_alphabet?(@alphabet).should == true
  end

  it "should be able to test if the string is not part of an alphabet" do
    "abde".in_alphabet?(@alphabet).should == false
  end

  it "empty strings should not belong to any alphabet" do
    "".in_alphabet?(@alphabet).should == false
  end
end
