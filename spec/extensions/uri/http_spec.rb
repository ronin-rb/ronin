require 'ronin/extensions/uri'

require 'spec_helper'

describe URI::HTTP do
  it "should include QueryParams" do
    URI::HTTP.include?(URI::QueryParams).should == true
  end

  it "should include Ronin::Scanners::Scanner" do
    URI::HTTP.include?(Ronin::Scanners::Scanner).should == true
  end
end
