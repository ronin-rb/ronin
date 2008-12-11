require 'ronin/chars/chars'

require 'spec_helper'

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

    @strings.each do |s|
      @chars.include_char?(s).should == true
    end
  end

  it "may be created with an Array of Strings" do
    @chars = Chars::CharSet.new(@strings)

    @strings.each do |s|
      @chars.include_char?(s).should == true
    end
  end

  it "may be created with a Range of Strings" do
    @chars = Chars::CharSet.new(@string_range)

    @strings.each do |s|
      @chars.include_char?(s).should == true
    end
  end

  it "may be created with Integer arguments" do
    @chars = Chars::CharSet.new(*@integers)

    @integers.each do |i|
      @chars.include?(i).should == true
    end
  end

  it "may be created with an Array of Integers" do
    @chars = Chars::CharSet.new(@integers)

    @integers.each do |i|
      @chars.include?(i).should == true
    end
  end

  it "may be created with a Range of Integers" do
    @chars = Chars::CharSet.new(@integer_range)

    @integers.each do |i|
      @chars.include?(i).should == true
    end
  end

  it "should include Strings" do
    @char_set.include_char?('A').should == true
  end

  it "should include Integers" do
    @char_set.include?(0x41).should == true
  end

  it "should be able to select bytes" do
    @sub_chars = @char_set.select_bytes { |c| c <= 0x42 }

    @sub_chars.should == [0x41, 0x42]
  end

  it "should be able to select chars" do
    @sub_chars = @char_set.select_chars { |c| c <= 'B' }

    @sub_chars.should == ['A', 'B']
  end

  it "should return a random byte" do
    @char_set.include?(@char_set.random_byte).should == true
  end

  it "should return a random char" do
    @char_set.include_char?(@char_set.random_char).should == true
  end

  it "should iterate over n random bytes" do
    @char_set.each_random_byte(10) do |b|
      @char_set.include?(b).should == true
    end
  end

  it "should iterate over n random chars" do
    @char_set.each_random_char(10) do |c|
      @char_set.include_char?(c).should == true
    end
  end

  it "should return a random Array of bytes" do
    bytes = @char_set.random_bytes(10)

    bytes.each do |b|
      @char_set.include?(b).should == true
    end
  end

  it "should return a random Array of chars" do
    chars = @char_set.random_chars(10)

    chars.each do |c|
      @char_set.include_char?(c).should == true
    end
  end

  it "should return a random Array of bytes with a varying length" do
    bytes = @char_set.random_bytes(5..10)

    bytes.length.between?(5, 10).should == true
    bytes.each do |b|
      @char_set.include?(b).should == true
    end
  end

  it "should return a random Array of chars with a varying length" do
    chars = @char_set.random_chars(5..10)

    chars.length.between?(5, 10).should == true
    chars.each do |c|
      @char_set.include_char?(c).should == true
    end
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
    (@char_set == Chars::CharSet['A', 'B', 'C']).should == true
    (@char_set == Chars::CharSet['A', 'C', 'B']).should == true
  end

  it "should be able to be unioned with another set of chars" do
    super_set = (@char_set | Chars::CharSet['D'])

    super_set.class.should == Chars::CharSet
    super_set.should == Chars::CharSet['A', 'B', 'C', 'D']
  end

  it "should be able to be removed from another set of chars" do
    sub_set = (@char_set - Chars::CharSet['B'])

    sub_set.class.should == Chars::CharSet
    sub_set.subset?(@char_set).should == true
  end

  it "should determine if a String is made up of the characters from the char set" do
    (@char_set =~ "AABCBAA").should == true
    (@char_set =~ "AADDEE").should_not == true
  end
end
