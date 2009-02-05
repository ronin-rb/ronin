require 'ronin/formatting/binary'

require 'spec_helper'

describe String do
  before(:all) do
    @packed_integer = ""
    @binary_string = "hello\x4e"
  end

  it "should provide String#depack" do
    @packed_integer.respond_to?('depack').should == true
  end

  it "should provide String#hex_escape" do
    @binary_string.respond_to?('hex_escape').should == true
  end

  it "should hex escape a String" do
    @binary_string.hex_escape.should == "\\x68\\x65\\x6c\\x6c\\x6f\\x4e"
  end

  describe "xor" do
    before(:all) do
      @string = 'hello'
      @key = 0x50
    end

    it "should not contain the key used in the xor" do
      @string.include?(@key).should_not == true
    end

    it "should not equal the original string" do
      @string.xor(@key).should_not == @string
    end

    it "should be able to be decoded with another xor" do
      @string.xor(@key).xor(@key).should == @string
    end
  end
end
