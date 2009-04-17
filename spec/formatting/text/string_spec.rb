require 'ronin/formatting/text'

require 'spec_helper'

describe String do
  before(:all) do
    @string = "hello"
  end

  it "should provide String#format_chars" do
    @string.respond_to?('format_chars').should == true
  end

  it "String#format_chars should format each character in the String" do
    @string.format_chars { |c|
      "_#{c}"
    }.should == "_h_e_l_l_o"
  end

  it "should provide String#format_bytes" do
    @string.respond_to?('format_bytes').should == true
  end

  it "String#format_bytes should format each byte in the String" do
    @string.format_bytes { |b|
      sprintf("%%%x",b)
    }.should == "%68%65%6c%6c%6f"
  end

  it "should provide String#random_case" do
    @string.respond_to?('random_case').should == true
  end

  it "String#random_case should randomly capitalize each character" do
    new_string = @string.random_case

    new_string.should_not == @string
    new_string.downcase.should == @string
  end
end
