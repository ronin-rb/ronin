require 'ronin/extensions/uri'

require 'spec_helper'

describe URI::QueryParams do
  before(:each) do
    @uri = URI('http://www.test.com/page.php?x=1&y=one%20two&z')
  end

  it "should provide #query_params" do
    @uri.should respond_to(:query_params)
  end

  it "#query_params should be a Hash" do
    @uri.query_params.class.should == Hash
  end

  it "#query_params should contain params" do
    @uri.query_params.should_not be_empty
  end

  it "#query_params can contain single-word params" do
    @uri.query_params['x'].should == '1'
  end

  it "#query_params can contain multi-word params" do
    @uri.query_params['y'].should == 'one two'
  end

  it "#query_params can contain empty params" do
    @uri.query_params['z'].should be_nil
  end

  it "should update #query_params along with #query=" do
    @uri.query = 'u=3'
    @uri.query_params['u'].should == '3'
  end

  it "should properly escape query param values" do
    @uri.query_params['x'] = '1&2'
    @uri.query_params['y'] = 'one=two'
    @uri.query_params['z'] = '?'

    @uri.to_s.should == "http://www.test.com/page.php?x=1%262&y=one%3Dtwo&z=%3F"
  end
end
