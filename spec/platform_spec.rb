require 'ronin/platform'

require 'spec_helper'

describe Platform do
  it "should require os and version attributes" do
    @platform = Platform.new
    @platform.should_not be_valid

    @platform.os = 'test'
    @platform.should_not be_valid

    @platform.version = '0.0.1'
    @platform.should be_valid
  end

  it "should provide methods for creating platforms for built-in OSes" do
    Platform.linux.should_not be_nil
  end

  it "should provide methods for creating platforms for built-in OSes with versions" do
    Platform.linux_version('2.6.11').should be_valid
  end
end
