require 'ronin/formatting/text'

describe Array do
  before(:all) do
    @byte_array = [0x41, 0x41, 0x20]
    @char_array = ['A', 'A', ' ']
    @mixed_array = ['AA', 0x20]
    @string = 'AA '
  end

  it "should provide Array#bytes" do
    Array.method_defined?(:bytes).should == true
  end

  it "should provide Array#chars" do
    Array.method_defined?(:chars).should == true
  end

  it "should provide Array#char_string" do
    Array.method_defined?(:char_string).should == true
  end

  describe "bytes" do
    it "should convert an Array of bytes to an Array of bytes" do
      @byte_array.bytes.should == @byte_array
    end

    it "should convert an Array of chars to an Array of bytes" do
      @char_array.bytes.should == @byte_array
    end

    it "should safely handle mixed byte/char/string Arrays" do
      @mixed_array.bytes.should == @byte_array
    end
  end

  describe "chars" do
    it "should convert an Array of bytes to an Array of chars" do
      @byte_array.chars.should == @char_array
    end

    it "should safely convert an Array of chars to an Array of chars" do
      @char_array.chars.should == @char_array
    end

    it "should safely handle mixed byte/char/string Arrays" do
      @mixed_array.chars.should == @char_array
    end
  end

  describe "char_string" do
    it "should convert an Array of bytes to a String" do
      @byte_array.char_string.should == @string
    end

    it "should convert an Array of chars to a String" do
      @char_array.char_string.should == @string
    end

    it "should safely handle mixed byte/char/string Arrays" do
      @mixed_array.char_string.should == @string
    end
  end
end
