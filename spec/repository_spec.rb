require 'spec_helper'
require 'helpers/repositories'

require 'ronin/repository'

describe Repository do
  include Helpers::Repositories

  subject { described_class }

  describe "find" do
    it "should be able to retrieve an Repository by name" do
      repo = subject.find('hello')

      repo.name.should == 'hello'
    end

    it "should be able to retrieve an Repository by name and domain" do
      repo = subject.find('hello/localhost')

      repo.name.should == 'hello'
      repo.domain.should == 'localhost'
    end

    it "should raise RepositoryNotFound for unknown Repository names" do
      lambda {
        subject.find('bla')
      }.should raise_error(RepositoryNotFound)
    end

    it "should raise RepositoryNotFound for unknown Repository names or domains" do
      lambda {
        subject.find('bla/bla')
      }.should raise_error(RepositoryNotFound)
    end
  end

  describe "add!" do
    it "should not add Repositorys without a path property" do
      lambda {
        subject.add!
      }.should raise_error(ArgumentError)
    end

    it "should not add Repositorys that do not point to a directory" do
      lambda {
        subject.add!(:path => 'path/to/nowhere')
      }.should raise_error(RepositoryNotFound)
    end

    it "should not allow adding an Repository from the same path twice" do
      lambda {
        subject.add!(:path => repository('hello').path)
      }.should raise_error(DuplicateRepository)
    end

    it "should not allow adding an Repository that was already installed" do
      lambda {
        subject.add!(:path => repository('random').path)
      }.should raise_error(DuplicateRepository)
    end
  end

  describe "install!" do
    it "should not allow installing an Repository with no URI" do
      lambda {
        subject.install!
      }.should raise_error(ArgumentError)
    end

    it "should not allow installing an Repository that was already added" do
      lambda {
        subject.install!(:uri => repository('test1').uri)
      }.should raise_error(DuplicateRepository)
    end

    it "should not allow installing an Repository from the same URI twice" do
      lambda {
        subject.install!(:uri => repository('random').uri)
      }.should raise_error(DuplicateRepository)
    end
  end

  describe "#domain" do
    it "should be considered local for 'localhost' domains" do
      hello = repository('hello')

      hello.should be_local
      hello.should_not be_remote
    end

    it "should be considered remote for non 'localhost' domains" do
      random = repository('random')

      random.should be_remote
      random.should_not be_local
    end
  end

  describe "#initialize" do
    it "should default the 'name' property to the name of the Repository directory" do
      repo = subject.new(
        :path => File.join(Helpers::Repositories::DIR,'hello')
      )

      repo.name.should == 'hello'
    end

    it "should default the 'installed' property to false" do
      repo = subject.new(
        :path => File.join(Helpers::Repositories::DIR,'hello'),
        :uri => 'git://github.com/path/to/hello.git'
      )

      repo.installed.should == false
    end
  end

  describe "#initialize_metadata" do
    subject { repository('hello') }

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
      subject.description.should == %{This is a test repo used in Ronin's specs.}
    end
  end

  describe "#activate!" do
    subject { repository('hello') }

    before(:all) do
      subject.activate!
    end

    it "should load the init.rb file if present" do
      $hello_repo_loaded.should == true
    end

    it "should make the lib directory accessible to Kernel#require" do
      require('stuff/test').should == true
    end
  end

  describe "#deactivate!" do
    subject { repository('hello') }

    before(:all) do
      subject.deactivate!
    end

    it "should make the lib directory unaccessible to Kernel#require" do
      lambda {
        require 'stuff/another_test'
      }.should raise_error(LoadError)
    end
  end

  describe "#each_script" do
    subject { repository('test1') }

    it "should list the contents of the 'cache/' directory" do
      subject.each_script.to_a.should_not be_empty
    end

    it "should only list '.rb' files" do
      subject.each_script.map { |path|
        path.extname
      }.uniq.should == ['.rb']
    end
  end

  describe "#script_paths" do
    let(:test1) { repository('test1') }
    let(:test2) { repository('test2') }

    describe "#cache_scripts!" do
      before(:all) do
        test1.cache_scripts!
        test2.cache_scripts!
      end

      it "should be populated script_paths" do
        test1.script_paths.should_not be_empty
      end

      it "should recover from files that contain syntax errors" do
        test2.script_paths.any? { |script_path|
          script_path.path.basename == Pathname.new('syntax_errors.rb')
        }.should == true
      end

      it "should recover from files that raised exceptions" do
        test2.script_paths.any? { |script_path|
          script_path.path.basename == Pathname.new('exceptions.rb')
        }.should == true
      end

      it "should recover from files that raise NoMethodError" do
        test2.script_paths.any? { |script_path|
          script_path.path.basename == Pathname.new('no_method_errors.rb')
        }.should == true
      end

      it "should recover from files that have validation errors" do
        test2.script_paths.any? { |script_path|
          script_path.path.basename == Pathname.new('validation_errors.rb')
        }.should == true
      end

      it "should clear script_paths before re-populate them" do
        test1_files = test1.script_paths.length
        test1.cache_scripts!

        test1.script_paths.length.should == test1_files
      end

      it "should be populated using the paths in the 'cache/' directory" do
        test1.script_paths.map { |file|
          file.path
        }.should == test1.each_script.to_a
      end
    end

    describe "#sync_scripts!" do
      before(:all) do
        test1.cache_scripts!
        test2.cache_scripts!

        file1 = test1.script_paths.first

        file1.timestamp -= 10
        file1.save

        test2.script_paths.clear

        test1.sync_scripts!
        test2.sync_scripts!
      end

      it "should update stale cached files" do
        script_path = test1.script_paths.first

        script_path.timestamp.should == File.mtime(script_path.path)
      end

      it "should cache new files" do
        test2.script_paths.should_not be_empty
      end
    end

    describe "#clean_scripts!" do
      before(:all) do
        test1.clean_scripts!
      end

      it "should clear the script_paths" do
        test1.script_paths.should be_empty
      end
    end
  end
end
