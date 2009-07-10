require 'ronin/extensions/uri'

require 'spec_helper'

describe URI::HTTP do
  it "should include QueryParams" do
    URI::HTTP.include?(URI::QueryParams).should == true
  end
end
