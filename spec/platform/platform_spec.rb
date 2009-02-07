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
end
