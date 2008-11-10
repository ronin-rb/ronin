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

    it "should be able to select a sub-charset" do
      @sub_chars = @char_set.select { |c| c <= 'B' }

      @sub_chars.class.should == Chars::CharSet
      @sub_chars.should == ['A', 'B']
    end

    it "should return a random char" do
      @char_set.include?(@char_set.random_char).should == true
    end

    it "should iterate over n random chars" do
      @char_set.each_random_char(10) do |c|
        @char_set.include?(c).should == true
      end
    end

    it "should return a random Array of chars" do
      arr = @char_set.random_array(10)
      
      (@char_set | arr).should == @char_set
    end

    it "should return a random Array of chars with a varying length" do
      arr = @char_set.random_array(5..10)

      arr.length.between?(5, 10).should == true
      (@char_set | arr).should == @char_set
    end

    it "should return a random String of chars" do
      @char_set.random_string(10).each_byte do |b|
        @char_set.include?(b).should == true
      end
    end

    it "should return a random String of chars with a varying length" do
      string = @char_set.random_string(5..10)

      string.length.between?(5, 10)
      string.each_byte do |b|
        @char_set.include?(b).should == true
      end
    end

    it "should be able to be compared with another set of chars" do
      (@char_set == ['A', 'B', 'C']).should == true
      (@char_set == ['A', 'C', 'B']).should == true
    end

    it "should be able to be unioned with another set of chars" do
      super_set = (@char_set | ['D'])

      super_set.class.should == Chars::CharSet

      (super_set & @char_set).should == @char_set
      super_set.include?('D').should == true
    end

    it "should be able to be removed from another set of chars" do
      sub_set = (@char_set - ['B'])

      (sub_set & ['A', 'C']).should == sub_set
    end
  end
end
