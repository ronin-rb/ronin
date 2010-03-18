require 'ronin/platform/overlay_cache'

require 'platform/helpers/overlays'
require 'spec_helper'

describe Platform::OverlayCache do
  include Helpers::Overlays

  before(:all) do
    @cache = OverlayCache.new
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

    overlays.should include(@cache.get('test1'))
    overlays.should include(@cache.get('test2'))
  end

  it "should return the paths to all the overlays" do
    paths = @cache.paths

    paths.length.should == 4
    paths.select { |path|
      path =~ /(test[12]|hello|random)$/
    }.should == paths
  end

  it "should have specific extensions" do
    @cache.has_extension?('test').should == true
  end

  it "should have extensions" do
    @cache.extensions.should == ['hello', 'random', 'test']
  end

  it "should provide the paths to specific extensions" do
    paths = @cache.extension_paths('test')

    paths.length.should == 2
    paths.select { |path| File.basename(path) == 'test.rb' }.should == paths
  end
end
