require 'ronin/chars/chars'

require 'spec_helper'

describe Ronin do
  describe Chars::CharSet do
    before(:all) do
      @integer_range = (0x41..0x43)
      @string_range = ('A'..'C')
      @integers = @integer_range.to_a
      @strings = @string_range.to_a

      @char_set = Chars::CharSet.new(*@strings)
    end

    it "may be created with String arguments" do
      @chars = Chars::CharSet.new(*@strings)

      @chars.should == @strings
    end

    it "may be created with an Array of Strings" do
      @chars = Chars::CharSet.new(@strings)

      @chars.should == @strings
    end

    it "may be created with a Range of Strings" do
      @chars = Chars::CharSet.new(@string_range)

      @chars.should == @strings
    end

    it "may be created with Integer arguments" do
      @chars = Chars::CharSet.new(*@integers)

      @chars.should == @strings
    end

    it "may be created with an Array of Integers" do
      @chars = Chars::CharSet.new(@integers)

      @chars.should == @strings
    end

    it "may be created with a Range of Integers" do
      @chars = Chars::CharSet.new(@integer_range)

      @chars.should == @strings
    end

    it "should include Strings" do
      @char_set.include?('A').should == true
    end

    it "should include Integers" do
      @char_set.include?(0x41).should == true
    end
  end
end
