require 'ronin/platform/overlay'

require 'spec_helper'
require 'platform/helpers/overlays'

describe Platform::Overlay do
  include Helpers::Overlays

  before(:all) do
    @overlay = load_overlay('hello')
  end

  it "should be compatible with the current Ronin::Platform::Overlay" do
    @overlay.should be_compatible
  end

  it "should not add Overlays without a path property" do
    lambda {
      Platform::Overlay.add!
    }.should raise_error(Platform::OverlayNotFound)
  end

  it "should not add Overlays that do not point to a directory" do
    lambda {
      Platform::Overlay.add!(:path => 'path/to/nowhere')
    }.should raise_error(Platform::OverlayNotFound)
  end

  describe "initialize_metadata" do
    it "should load the format version" do
      @overlay.version.should_not be_nil
    end

    it "should load the title" do
      @overlay.title.should == 'Hello World'
    end

    it "should load the website" do
      @overlay.website.should == 'http://ronin.rubyforge.org/'
    end

    it "should load the license" do
      @overlay.license.should_not be_nil
      @overlay.license.name.should == 'GPL-2'
    end

    it "should load the maintainers" do
      @overlay.maintainers.find { |maintainer|
        maintainer.name == 'Postmodern' && \
          maintainer.email == 'postmodern.mod3@gmail.com'
      }.should_not be_nil
    end

    it "should load the description" do
      @overlay.description.should == %{This is a test overlay used in Ronin's specs.}
    end
  end

  describe "activate!" do
    before(:all) do
      @overlay.activate!
    end

    it "should load the init.rb file if present" do
      $hello_overlay_loaded.should == true
    end

    it "should make the lib directory accessible to Kernel#require" do
      require('stuff/test').should == true
    end
  end

  describe "deactivate!" do
    before(:all) do
      @overlay.deactivate!
    end

    it "should make the lib directory unaccessible to Kernel#require" do
      lambda {
        require 'stuff/another_test'
      }.should raise_error(LoadError)
    end
  end
end
