require 'ronin/formatting/text'

require 'spec_helper'

describe String do
  before(:all) do
    @string = ""
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
end
