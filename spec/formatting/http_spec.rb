require 'ronin/formatting/http'

require 'spec_helper'

describe String do
  before(:all) do
    @uri_unencoded = "mod % 3"
    @uri_encoded = "mod%20%25%203"
    @uri_unescaped = "x + y"
    @uri_escaped = "x+%2B+y"
  end

  it "should provide String#uri_encode" do
    @uri_unencoded.respond_to?('uri_encode').should == true
  end

  it "String#uri_encode should URI encode itself" do
    @uri_unencoded.uri_encode.should == @uri_encoded
  end

  it "should provide String#uri_decode" do
    @uri_encoded.respond_to?('uri_decode').should == true
  end

  it "String#uri_decode should URI decode itself" do
    @uri_encoded.uri_decode.should == @uri_unencoded
  end

  it "should provide String#uri_escape" do
    @uri_unescaped.respond_to?('uri_escape').should == true
  end

  it "String#uri_escape should URI escape itself" do
    @uri_unescaped.uri_escape.should == @uri_escaped
  end

  it "should provide String#uri_unescape" do
    @uri_escaped.respond_to?('uri_unescape').should == true
  end

  it "String#uri_unescape should URI unescape itself" do
    @uri_escaped.uri_unescape.should == @uri_unescaped
  end
end
