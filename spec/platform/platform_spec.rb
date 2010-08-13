require 'spec_helper'
require 'platform/spec_helper'
require 'ronin/platform/platform'

describe Platform do
  it "should be able to load custom overlay caches" do
    subject.overlays.should_not be_empty
  end

  it "should have specific extensions" do
    subject.has_extension?('test').should == true
  end

  it "should provide the names of all available extensions" do
    subject.extension_names.should == ['hello', 'random', 'test']
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
    ext = subject.hello

    ext.should_not be_nil
    ext.name.should == 'hello'
    ext.greatings.should == 'hello'
  end

  it "should raise NoMethodError when accessing missing extensions" do
    lambda { subject.nothing }.should raise_error(NoMethodError)
  end
end
