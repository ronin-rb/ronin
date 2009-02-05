require 'ronin/platform/extension_cache'

require 'platform/helpers/overlays'

describe Platform::ExtensionCache do
  before(:all) do
    Platform.load_overlays(OVERLAY_CACHE)

    @cache = Platform::ExtensionCache.new
  end

  it "should be able to load an extension from the overlays" do
    ext = @cache.load_extension('test')

    ext.should_not be_nil
    ext.name.should == 'test'
  end
end
