require 'ronin/platform/platform'

require 'spec_helper'
require 'platform/helpers/overlays'

describe Platform do
  include Helpers

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

  it "should provide transparent access to extensions via methods" do
    ext = Platform::Hello

    ext.should_not be_nil
    ext.name.should == 'hello'
    ext.greatings.should == 'hello'
  end

  it "should raise NameError when accessing missing extensions" do
    lambda { Platform::Nothing }.should raise_error(NameError)
  end

  it "should provide transparent access to extensions via methods" do
    ext = Platform.hello

    ext.should_not be_nil
    ext.name.should == 'hello'
    ext.greatings.should == 'hello'
  end

  it "should raise NoMethodError when accessing missing extensions" do
    lambda { self.nothing }.should raise_error(NoMethodError)
  end
end
