require 'ronin/platform/overlay'

require 'platform/helpers/overlays'
require 'spec_helper'

describe Platform::Overlay do
  describe "initialize_metadata" do
    before(:all) do
      @overlay = Platform::Overlay.new(File.join(OVERLAY_CACHE,'hello'))
    end

    it "should load the title" do
      @overlay.title.should == 'Hello World'
    end

    it "should load the website" do
      @overlay.website.should == 'http://ronin.rubyforge.org/'
    end

    it "should load the license" do
      @overlay.license.should == 'GPL-2'
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
      @overlay = Platform::Overlay.new(File.join(OVERLAY_CACHE,'hello'))
      @overlay.activate!
    end

    it "should load the init.rb file if present" do
      @@hello_overlay_loaded.should == true
    end

    it "should make the lib directory accessible to Kernel#require" do
      require('stuff/test').should == true
    end
  end

  describe "deactive!" do
    before(:all) do
      @overlay = Platform::Overlay.new(File.join(OVERLAY_CACHE,'hello'))
      @overlay.deactivate!
    end

    it "should make the lib directory unaccessible to Kernel#require" do
      lambda {
        require 'stuff/another_test'
      }.should raise_error(LoadError)
    end
  end
end
