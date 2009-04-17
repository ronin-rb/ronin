require 'ronin/formatting/http'

require 'spec_helper'

describe String do
  before(:all) do
    @string = "mod % 3"
  end

  it "should provide String#uri_encode" do
    @string.respond_to?('uri_encode').should == true
  end

  it "should provide String#uri_decode" do
    @string.respond_to?('uri_decode').should == true
  end

  it "should provide String#uri_escape" do
    @string.respond_to?('uri_escape').should == true
  end

  it "should provide String#uri_unescape" do
    @string.respond_to?('uri_unescape').should == true
  end

  it "should provide String#format_http" do
    @string.respond_to?('format_http').should == true
  end

  describe "uri_encode" do
    before(:all) do
      @uri_unencoded = "mod % 3"
      @uri_encoded = "mod%20%25%203"
    end

    it "should URI encode itself" do
      @uri_unencoded.uri_encode.should == @uri_encoded
    end
  end

  describe "uri_decode" do
    before(:all) do
      @uri_unencoded = "mod % 3"
      @uri_encoded = "mod%20%25%203"
    end

    it "should URI decode itself" do
      @uri_encoded.uri_decode.should == @uri_unencoded
    end
  end

  describe "uri_escape" do
    before(:all) do
      @uri_unescaped = "x + y"
      @uri_escaped = "x+%2B+y"
    end

    it "should URI escape itself" do
      @uri_unescaped.uri_escape.should == @uri_escaped
    end
  end

  describe "uri_unescape" do
    before(:all) do
      @uri_unescaped = "x + y"
      @uri_escaped = "x+%2B+y"
    end

    it "should URI unescape itself" do
      @uri_escaped.uri_unescape.should == @uri_unescaped
    end
  end

  describe "format_http" do
    before(:all) do
      @uri_unencoded = "mod % 3"
      @uri_http_encoded = "%6d%6f%64%20%25%20%33"
    end

    it "should format each byte of the String" do
      @uri_unencoded.format_http.should == @uri_http_encoded
    end
  end
end
