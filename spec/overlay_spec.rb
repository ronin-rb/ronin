require 'spec_helper'
require 'helpers/overlays'
require 'model/models/cacheable_model'

require 'ronin/overlay'

describe Overlay do
  include Helpers::Overlays

  subject { Overlay }

  describe "find" do
    it "should be able to retrieve an Overlay by name" do
      overlay = subject.find('hello')

      overlay.name.should == 'hello'
    end

    it "should be able to retrieve an Overlay by name and domain" do
      overlay = subject.find('hello/localhost')

      overlay.name.should == 'hello'
      overlay.domain.should == 'localhost'
    end

    it "should raise OverlayNotFound for unknown Overlay names" do
      lambda {
        subject.find('bla')
      }.should raise_error(OverlayNotFound)
    end

    it "should raise OverlayNotFound for unknown Overlay names or domains" do
      lambda {
        subject.find('bla/bla')
      }.should raise_error(OverlayNotFound)
    end
  end

  describe "add!" do
    it "should not add Overlays without a path property" do
      lambda {
        subject.add!
      }.should raise_error(ArgumentError)
    end

    it "should not add Overlays that do not point to a directory" do
      lambda {
        subject.add!(:path => 'path/to/nowhere')
      }.should raise_error(OverlayNotFound)
    end

    it "should not allow adding an Overlay from the same path twice" do
      lambda {
        subject.add!(:path => load_overlay('hello').path)
      }.should raise_error(DuplicateOverlay)
    end

    it "should not allow adding an Overlay that was already installed" do
      lambda {
        subject.add!(:path => load_overlay('random').path)
      }.should raise_error(DuplicateOverlay)
    end
  end

  describe "install!" do
    it "should not allow installing an Overlay with no URI" do
      lambda {
        subject.install!
      }.should raise_error(ArgumentError)
    end

    it "should not allow installing an Overlay that was already added" do
      lambda {
        subject.install!(:uri => load_overlay('test1').uri)
      }.should raise_error(DuplicateOverlay)
    end

    it "should not allow installing an Overlay from the same URI twice" do
      lambda {
        subject.install!(:uri => load_overlay('random').uri)
      }.should raise_error(DuplicateOverlay)
    end
  end

  describe "domain" do
    it "should be considered local for 'localhost' domains" do
      hello = load_overlay('hello')

      hello.should be_local
      hello.should_not be_remote
    end

    it "should be considered remote for non 'localhost' domains" do
      random = load_overlay('random')

      random.should be_remote
      random.should_not be_local
    end
  end

  describe "initialize" do
    it "should default the 'name' property to the name of the Overlay directory" do
      overlay = subject.new(
        :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'hello')
      )

      overlay.name.should == 'hello'
    end

    it "should default the 'installed' property to false" do
      overlay = subject.new(
        :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'hello'),
        :uri => 'git://github.com/path/to/hello.git'
      )

      overlay.installed.should == false
    end
  end

  describe "initialize_metadata" do
    subject { load_overlay('hello') }

    it "should load the title" do
      subject.title.should == 'Hello World'
    end

    it "should load the website" do
      website = Addressable::URI.parse('http://ronin.rubyforge.org/')

      subject.website.should == website
    end

    it "should load the license" do
      subject.license.should_not be_nil
      subject.license.name.should == 'GPL-2'
    end

    it "should load the maintainers" do
      author = subject.authors.find { |author|
        author.name == 'Postmodern' &&
        author.email == 'postmodern.mod3@gmail.com'
      }
      
      author.should_not be_nil
    end

    it "should load the description" do
      subject.description.should == %{This is a test overlay used in Ronin's specs.}
    end
  end

  describe "activate!" do
    subject { load_overlay('hello') }

    before(:all) do
      subject.activate!
    end

    it "should load the init.rb file if present" do
      $hello_overlay_loaded.should == true
    end

    it "should make the lib directory accessible to Kernel#require" do
      require('stuff/test').should == true
    end
  end

  describe "deactivate!" do
    subject { load_overlay('hello') }

    before(:all) do
      subject.deactivate!
    end

    it "should make the lib directory unaccessible to Kernel#require" do
      lambda {
        require 'stuff/another_test'
      }.should raise_error(LoadError)
    end
  end

  describe "cache_paths" do
    subject { load_overlay('test1') }

    it "should list the contents of the 'cache/' directory" do
      subject.cache_paths.should_not be_empty
    end

    it "should only list '.rb' files" do
      subject.cache_paths.should_not be_empty

      subject.cache_paths.all? { |path|
        path.extname.should == '.rb'
      }.should == true
    end
  end

  describe "cached_files" do
    before(:all) do
      CacheableModel.auto_migrate!
    end

    let(:test1) { load_overlay('test1') }
    let(:test2) { load_overlay('test2') }

    describe "cache_files!" do
      before(:all) do
        test1.cache_files!
        test2.cache_files!
      end

      it "should be populated cached_files" do
        test1.cached_files.should_not be_empty
      end

      it "should recover from files that contain syntax errors" do
        test2.cached_files.any? { |cached_file|
          cached_file.path.basename == Pathname.new('syntax_errors.rb')
        }.should == true
      end

      it "should recover from files that raised exceptions" do
        test2.cached_files.any? { |cached_file|
          cached_file.path.basename == Pathname.new('exceptions.rb')
        }.should == true
      end

      it "should recover from files that raise NoMethodError" do
        test2.cached_files.any? { |cached_file|
          cached_file.path.basename == Pathname.new('no_method_errors.rb')
        }.should == true
      end

      it "should recover from files that have validation errors" do
        test2.cached_files.any? { |cached_file|
          cached_file.path.basename == Pathname.new('validation_errors.rb')
        }.should == true
      end

      it "should clear cached_files before re-populate them" do
        test1_files = test1.cached_files.length
        test1.cache_files!

        test1.cached_files.length.should == test1_files
      end

      it "should be populated using the paths in the 'cache/' directory" do
        test1.cached_files.map { |file|
          file.path
        }.should == test1.cache_paths
      end
    end

    describe "sync_cached_files!" do
      before(:all) do
        test1.cache_files!
        test2.cache_files!

        file1 = test1.cached_files.first

        file1.timestamp -= 10
        file1.save

        test2.cached_files.clear

        test1.sync_cached_files!
        test2.sync_cached_files!
      end

      it "should update stale cached files" do
        cached_file = test1.cached_files.first

        cached_file.timestamp.should == File.mtime(cached_file.path)
      end

      it "should cache new files" do
        test2.cached_files.should_not be_empty
      end
    end

    describe "clean_cached_files!" do
      before(:all) do
        test1.clean_cached_files!
      end

      it "should clear the cached_files" do
        test1.cached_files.should be_empty
      end
    end
  end
end
