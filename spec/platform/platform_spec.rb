require 'ronin/platform/platform'

require 'platform/helpers/overlays'
require 'spec_helper'

describe Platform do
  before(:all) do
    Platform.load_overlays(overlay_cache_path)
  end

  it "should be able to load custom overlay caches" do
    Platform.overlays.should_not be_empty
  end

  it "should have specific extensions" do
    Platform.has_extension?('test').should == true
  end

  it "should provide the names of all available extensions" do
    Platform.extension_names.should == ['hello', 'random', 'test']
  end
end
