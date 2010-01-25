require 'ronin/scanners/extensions'

require 'spec_helper'

describe Scanners do
  it "should include Scanner into IPAddr" do
    IPAddr.ancestors.should include(Scanners::Scanner)
  end

  it "should include Scanner into URI::HTTP" do
    URI::HTTP.ancestors.should include(Scanners::Scanner)
  end
end
