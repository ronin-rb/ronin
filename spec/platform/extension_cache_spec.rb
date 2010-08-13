require 'spec_helper'
require 'platform/spec_helper'

require 'ronin/platform/extension_cache'

describe Platform::ExtensionCache do
  it "should be able to load an extension from the overlays" do
    ext = subject.load_extension('test')

    ext.should_not be_nil
    ext.name.should == 'test'
  end

  it "should determine if an extension was loaded" do
    subject['test']
    subject.has?('test').should == true
  end

  it "should select extensions with specific attributes" do
    test = subject['test']
    random = subject['random']

    subject.with { |ext| ext.name == 'test' }.should == [test]
  end

  it "should provide transparent caching of extensions" do
    ext = subject['test']
    ext.should_not be_nil
    ext.name.should == 'test'

    subject['test'].should == ext
  end

  it "should load together the extension from all overlays" do
    ext = subject.load_extension('test')

    ext.should_not be_nil
    ext.test1.should == 'test one'
    ext.test2.should == 'test two'
  end

  it "should have loaded extensions with multiple paths" do
    paths = subject.load_extension('test').paths

    paths.length.should == 2
    paths.select { |path| path =~ /test\.rb$/ }.should == paths
  end

  it "should reload previously loaded extensions" do
    random_number = lambda { subject['random'].number }
    previous_number = random_number.call

    subject.reload!
    random_number.call.should_not == previous_number
  end
end
