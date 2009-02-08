require 'ronin/chars/chars'

require 'spec_helper'

describe Chars do
  before(:all) do
    @numeric_string = Chars.numeric.random_string(10)
    @octal_string = Chars.octal.random_string(10)
    @uppercase_hex_string = Chars.uppercase_hexadecimal.random_string(10)
    @lowercase_hex_string = Chars.lowercase_hexadecimal.random_string(10)
    @hex_string = Chars.hexadecimal.random_string(10)
    @uppercase_alpha_string = Chars.uppercase_alpha.random_string(10)
    @lowercase_alpha_string = Chars.lowercase_alpha.random_string(10)
    @alpha_string = Chars.alpha.random_string(10)
    @alpha_numeric_string = Chars.alpha_numeric.random_string(10)
    @space_string = Chars.space.random_string(10)
    @punctuation_string = Chars.punctuation.random_string(10)
    @symbols_string = Chars.symbols.random_string(10)
    @control_string = Chars.control.random_string(10)
    @ascii_string = Chars.ascii.random_string(10)
    @all_string = Chars.all.random_string(10)
  end

  it "should provide a numeric CharSet" do
    @numeric_string.length.should == 10
    @numeric_string.each_byte do |b|
      Chars::NUMERIC.include?(b).should == true
    end
  end

  it "should provide an octal CharSet" do
    @octal_string.length.should == 10
    @octal_string.each_byte do |b|
      Chars::OCTAL.include?(b).should == true
    end
  end

  it "should provide an upper-case hexadecimal CharSet" do
    @uppercase_hex_string.length.should == 10
    @uppercase_hex_string.each_byte do |b|
      Chars::UPPERCASE_HEXADECIMAL.include?(b).should == true
    end
  end

  it "should provide a lower-case hexadecimal CharSet" do
    @lowercase_hex_string.length.should == 10
    @lowercase_hex_string.each_byte do |b|
      Chars::LOWERCASE_HEXADECIMAL.include?(b).should == true
    end
  end

  it "should provide a hexadecimal CharSet" do
    @hex_string.length.should == 10
    @hex_string.each_byte do |b|
      Chars::HEXADECIMAL.include?(b).should == true
    end
  end

  it "should provide an upper-case alpha CharSet" do
    @uppercase_alpha_string.length.should == 10
    @uppercase_alpha_string.each_byte do |b|
      Chars::UPPERCASE_ALPHA.include?(b).should == true
    end
  end

  it "should provide a lower-case alpha CharSet" do
    @lowercase_alpha_string.length.should == 10
    @lowercase_alpha_string.each_byte do |b|
      Chars::LOWERCASE_ALPHA.include?(b).should == true
    end
  end

  it "should provide an alpha CharSet" do
    @alpha_string.length.should == 10
    @alpha_string.each_byte do |b|
      Chars::ALPHA.include?(b).should == true
    end
  end

  it "should provide an alpha-numeric CharSet" do
    @alpha_numeric_string.length.should == 10
    @alpha_numeric_string.each_byte do |b|
      Chars::ALPHA_NUMERIC.include?(b).should == true
    end
  end

  it "should provide a space CharSet" do
    @space_string.length.should == 10
    @space_string.each_byte do |b|
      Chars::SPACE.include?(b).should == true
    end
  end

  it "should provide a punctuation CharSet" do
    @punctuation_string.length.should == 10
    @punctuation_string.each_byte do |b|
      Chars::PUNCTUATION.include?(b).should == true
    end
  end

  it "should provide a symbols CharSet" do
    @symbols_string.length.should == 10
    @symbols_string.each_byte do |b|
      Chars::SYMBOLS.include?(b).should == true
    end
  end
end
