require 'ronin/platform/overlay_cache'

require 'platform/helpers/overlays'

describe Platform::OverlayCache do
  before(:all) do
    @cache = Platform::OverlayCache.new(OVERLAY_CACHE)
  end

  it "should not be dirty by default" do
    @cache.should_not be_dirty
  end

  it "should not be empty" do
    @cache.should_not be_empty
  end

  it "should have specific overlays" do
    @cache.has?('test1').should == true
  end

  it "should return specific overlays" do
    @cache.get('test1').name.should == 'test1'
  end

  it "should raise an OverlayNotFound exception when requesting missing overlays" do
    lambda {
      @cache.get('nothing')
    }.should raise_error(Platform::OverlayNotFound)
  end

  it "should be able to select overlays with certain attributes" do
    overlays = @cache.with do |overlay|
      overlay.name =~ /^test/
    end

    overlays.include?(@cache.get('test1')).should == true
    overlays.include?(@cache.get('test2')).should == true
  end

  it "should return the paths to all the overlays" do
    paths = @cache.paths

    paths.select { |path| path =~ /test[12]$/ }.should == paths
  end
end
