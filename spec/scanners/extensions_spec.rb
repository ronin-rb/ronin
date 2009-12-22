require 'ronin/scanners/extensions'

require 'spec_helper'

describe Scanners do
  it "should include Scanner into IPAddr" do
    IPAddr.ancestors.include?(Scanners::Scanner)
  end

  it "should include Scanner into URI::HTTP" do
    URI::HTTP.ancestors.include?(Scanners::Scanner)
  end
end
