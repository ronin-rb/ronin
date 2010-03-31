require 'ronin/platform/overlay'

require 'spec_helper'
require 'platform/helpers/overlays'

describe Platform::Overlay do
  include Helpers::Overlays

  before(:all) do
    @overlay = load_overlay('hello')
  end

  describe "get" do
    it "should be able to retrieve an Overlay by name" do
      overlay = Platform::Overlay.get('hello')

      overlay.name.should == 'hello'
    end

    it "should be able to retrieve an Overlay by name and domain" do
      overlay = Platform::Overlay.get('hello/localhost')

      overlay.name.should == 'hello'
      overlay.domain.should == 'localhost'
    end

    it "should raise OverlayNotFound for unknown Overlay names" do
      lambda {
        Platform::Overlay.get('bla')
      }.should raise_error(Platform::OverlayNotFound)
    end

    it "should raise OverlayNotFound for unknown Overlay names or domains" do
      lambda {
        Platform::Overlay.get('bla/bla')
      }.should raise_error(Platform::OverlayNotFound)
    end
  end

  describe "add!" do
    it "should not add Overlays without a path property" do
      lambda {
        Platform::Overlay.add!
      }.should raise_error(ArgumentError)
    end

    it "should not add Overlays that do not point to a directory" do
      lambda {
        Platform::Overlay.add!(:path => 'path/to/nowhere')
      }.should raise_error(Platform::OverlayNotFound)
    end

    it "should not allow adding an Overlay from the same path twice" do
      lambda {
        Platform::Overlay.add!(:path => load_overlay('hello').path)
      }.should raise_error(Platform::DuplicateOverlay)
    end

    it "should not allow adding an Overlay that was already installed" do
      lambda {
        Platform::Overlay.add!(:path => load_overlay('random').path)
      }.should raise_error(Platform::DuplicateOverlay)
    end
  end

  describe "install!" do
    it "should not allow installing an Overlay with no URI" do
      lambda {
        Platform::Overlay.install!
      }.should raise_error(ArgumentError)
    end

    it "should not allow installing an Overlay that was already added" do
      lambda {
        Platform::Overlay.install!(:uri => load_overlay('test1').uri)
      }.should raise_error(Platform::DuplicateOverlay)
    end

    it "should not allow installing an Overlay from the same URI twice" do
      lambda {
        Platform::Overlay.install!(:uri => load_overlay('random').uri)
      }.should raise_error(Platform::DuplicateOverlay)
    end
  end

  describe "initialize" do
    it "should default the 'name' property to the name of the Overlay directory" do
      overlay = Platform::Overlay.new(
        :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'hello')
      )

      overlay.name.should == 'hello'
    end

    it "should default the 'installed' property to false" do
      overlay = Platform::Overlay.new(
        :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'hello'),
        :uri => 'git://github.com/path/to/hello.git'
      )

      overlay.installed.should == false
    end
  end

  describe "initialize_metadata" do
    it "should load the format version" do
      @overlay.version.should_not be_nil
    end

    it "should be compatible with the current Ronin::Platform::Overlay" do
      @overlay.should be_compatible
    end

    it "should load the title" do
      @overlay.title.should == 'Hello World'
    end

    it "should load the website" do
      website = Addressable::URI.parse('http://ronin.rubyforge.org/')

      @overlay.website.should == website
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

  describe "cache_paths" do
    before(:all) do
      @test1 = load_overlay('test1')
    end

    it "should list the contents of the 'cache/' directory" do
      @test1.cache_paths.should_not be_empty

      @test1.cache_paths.all? { |path|
        path.include?('cache')
      }.should == true
    end

    it "should only list '.rb' files" do
      @test1.cache_paths.should_not be_empty

      @test1.cache_paths.all? { |path|
        File.extname(path).should == '.rb'
      }.should == true
    end
  end

  describe "cached_files" do
    before(:all) do
      @test1 = load_overlay('test1')
      @test2 = load_overlay('test2')
    end

    describe "save_cached_files!" do
      before(:all) do
        @test1.save_cached_files!
        @test2.save_cached_files!
      end

      it "should be populated cached_files" do
        @test1.cached_files.should_not be_empty
        @test2.cached_files.should_not be_empty
      end

      it "should clear cached_files before re-populate them" do
        test1_files = @test1.cached_files.length
        test2_files = @test2.cached_files.length

        @test1.save_cached_files!
        @test2.save_cached_files!

        @test1.cached_files.length.should == test1_files
        @test2.cached_files.length.should == test2_files
      end

      it "should be populated using the paths in the 'cache/' directory" do
        @test1.cached_files.map { |file|
          file.path
        }.should == @test1.cache_paths

        @test2.cached_files.map { |file|
          file.path
        }.should == @test2.cache_paths
      end
    end

    describe "sync_cached_files!" do
      before(:all) do
        @test1.save_cached_files!
        @test2.save_cached_files!

        file1 = @test1.cached_files.first

        file1.timestamp -= 10
        file1.save

        @test2.cached_files.clear

        @test1.sync_cached_files!
        @test2.sync_cached_files!
      end

      it "should update stale cached files" do
        cached_file = @test1.cached_files.first

        cached_file.timestamp.should == File.mtime(cached_file.path).to_i
      end

      it "should cache new files" do
        @test2.cached_files.should_not be_empty
      end
    end

    describe "clean_cached_files!" do
      before(:all) do
        @test1.clean_cached_files!
        @test2.clean_cached_files!
      end

      it "should clear the cached_files" do
        @test1.cached_files.should be_empty
        @test2.cached_files.should be_empty
      end
    end
  end
end
