require 'ronin/formatting/text'

require 'spec_helper'

describe String do
  before(:all) do
    @string = "hello"
  end

  it "should provide String#format_chars" do
    @string.respond_to?('format_chars').should == true
  end

  it "should provide String#format_bytes" do
    @string.respond_to?('format_bytes').should == true
  end

  it "should provide String#random_case" do
    @string.respond_to?('random_case').should == true
  end

  describe "format_chars" do
    it "should format each character in the String" do
      @string.format_chars { |c|
        "_#{c}"
      }.should == "_h_e_l_l_o"
    end
  end

  describe "format_bytes" do
    it "should format each byte in the String" do
      @string.format_bytes { |b|
        sprintf("%%%x",b)
      }.should == "%68%65%6c%6c%6f"
    end
  end

  describe "random_case" do
    it "should capitalize each character when :probability is 1.0" do
      new_string = @string.random_case(:probability => 1.0)

      @string.upcase.should == new_string
    end

    it "should not capitalize any characters when :probability is 0.0" do
      new_string = @string.random_case(:probability => 0.0)

      @string.should == new_string
    end
  end
end
