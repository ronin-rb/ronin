require 'ronin/extensions/uri'

require 'spec_helper'

describe URI::HTTP do
  it "should include QueryParams" do
    URI::HTTP.include?(URI::QueryParams).should == true
  end

  it "should have explodable query params" do
    @url = URI('http://search.dhgate.com/search.do?dkp=1&searchkey=yarn&catalog=')

    @urls = @url.explode_query_params('x')
    @urls.each do |param,new_url|
      new_url.query_params[param].should == 'x'
    end
  end

  it "should only explode query params with specified params" do
    @params = ['dkp', 'catalog']
    @url = URI('http://search.dhgate.com/search.do?dkp=1&searchkey=yarn&catalog=')

    @urls = @url.explode_query_params('x', :included => @params)
    @urls.each do |param,new_url|
      @params.include?(param).should == true
      new_url.query_params[param].should == 'x'
    end
  end

  it "should not explode query params with certain params" do
    @params = ['searchkey']
    @url = URI('http://search.dhgate.com/search.do?dkp=1&searchkey=yarn&catalog=')

    @urls = @url.explode_query_params('x', :excluded => @params)
    @urls.each do |param,new_url|
      @params.include?(param).should == false
      new_url.query_params[param].should == 'x'
    end
  end
end
