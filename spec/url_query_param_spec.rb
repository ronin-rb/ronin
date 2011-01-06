require 'spec_helper'
require 'ronin/url_query_param'

describe URLQueryParam do
  it "should require a name" do
    param = URLQueryParam.new

    param.should_not be_valid
  end

  describe "#to_s" do
    it "should dump a name and a value into a String" do
      param = URLQueryParam.new(:name => 'foo', :value => 'bar')

      param.to_s.should == "foo=bar"
    end

    it "should ignore empty or nil values" do
      param = URLQueryParam.new(:name => 'foo')

      param.to_s.should == "foo="
    end

    it "should escape special characters" do
      param = URLQueryParam.new(:name => 'foo', :value => 'bar baz')

      param.to_s.should == "foo=bar%20baz"
    end
  end
end
