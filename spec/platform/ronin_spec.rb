require 'ronin/platform/ronin'

require 'platform/helpers/overlays'
require 'spec_helper'

describe Ronin do
  before(:all) do
    Platform.load_overlays(overlay_cache_path)
  end

  it "should provide transparent access to extensions via methods" do
    ext = Ronin::Hello

    ext.should_not be_nil
    ext.name.should == 'hello'
    ext.greatings.should == 'hello'
  end

  it "should raise NameError when accessing missing extensions" do
    lambda { Ronin::Nothing }.should raise_error(NameError)
  end

  it "should provide transparent access to extensions via methods" do
    ext = Ronin.hello

    ext.should_not be_nil
    ext.name.should == 'hello'
    ext.greatings.should == 'hello'
  end

  it "should raise NoMethodError when accessing missing extensions" do
    lambda { Ronin.nothing }.should raise_error(NoMethodError)
  end
end
