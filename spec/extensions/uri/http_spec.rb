require 'ronin/extensions/uri'

require 'spec_helper'

describe URI::HTTP do
  it "should include QueryParams" do
    URI::HTTP.should include(URI::QueryParams)
  end

  it "should include Ronin::Scanners::Scanner" do
    URI::HTTP.should include(Ronin::Scanners::Scanner)
  end
end
