require 'ronin/platform/extension_cache'

require 'platform/helpers/overlays'
require 'spec_helper'

describe Platform::ExtensionCache do
  before(:all) do
    Platform.load_overlays(overlay_cache_path)
  end

  before(:each) do
    @cache = Platform::ExtensionCache.new
  end

  it "should be able to load an extension from the overlays" do
    ext = @cache.load_extension('test')

    ext.should_not be_nil
    ext.name.should == 'test'
  end

  it "should determine if an extension was loaded" do
    @cache['test']
    @cache.has?('test').should == true
  end

  it "should select extensions with specific attributes" do
    test = @cache['test']
    random = @cache['random']

    @cache.with { |ext| ext.name == 'test' }.should == [test]
  end

  it "should provide transparent caching of extensions" do
    ext = @cache['test']
    ext.should_not be_nil
    ext.name.should == 'test'

    @cache['test'].should == ext
  end

  it "should load together the extension from all overlays" do
    ext = @cache.load_extension('test')

    ext.should_not be_nil
    ext.test1.should == 'test one'
    ext.test2.should == 'test two'
  end

  it "should have loaded extensions with multiple paths" do
    paths = @cache.load_extension('test').paths

    paths.length.should == 2
    paths.select { |path| path =~ /test$/ }.should == paths
  end

  it "should reload previously loaded extensions" do
    random_number = lambda { @cache['random'].number }
    previous_number = random_number.call

    @cache.reload!
    random_number.call.should_not == previous_number
  end
end
