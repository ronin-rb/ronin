require 'spec_helper'
require 'platform/spec_helper'

require 'ronin/platform/overlay_cache'

describe Platform::OverlayCache do
  it "should not be empty" do
    should_not be_empty
  end

  it "should return the paths to all the overlays" do
    paths = subject.paths

    paths.length.should == 4

    paths.map { |path|
      path.basename.to_s
    }.should =~ ['hello', 'random', 'test1', 'test2']
  end

  it "should have specific extensions" do
    subject.has_extension?('test').should == true
  end

  it "should have extensions" do
    subject.extensions.should == ['hello', 'random', 'test']
  end

  it "should provide the paths to specific extensions" do
    paths = subject.extension_paths('test')

    paths.length.should == 2
    paths.select { |path|
      File.basename(path) == 'test.rb'
    }.should == paths
  end
end
