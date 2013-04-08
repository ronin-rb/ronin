require 'spec_helper'
require 'helpers/repositories'
require 'classes/my_script'

require 'ronin/script/path'

describe Script::Path do
  include Helpers::Repositories

  let(:repo) { repository('scripts') }
  let(:script_class) { MyScript }

  before(:all) { repo.cache_scripts! }

  describe "cached file" do
    subject { repo.find_script('cached/cached.rb') }

    it "should be saved" do
      subject.should be_saved
    end

    it "should have a path" do
      subject.path.should_not be_nil
    end

    it "should have a timestamp" do
      subject.timestamp.should_not be_nil
    end

    it "should not have updated code" do
      subject.should_not be_updated
    end

    it "should not have cache exceptions" do
      subject.cache_exception.should be_nil
    end

    it "should not have cache errors" do
      subject.cache_errors.should be_nil
    end

    it "should have the model name of the cached object" do
      subject.class_name.should == script_class.name
    end

    it "should have the model path of the cached object" do
      subject.class_path.should == 'my_script'
    end

    it "should be able to load the Model of the cached object" do
      subject.script_class.should == script_class
    end

    it "should be able to load a fresh model from the cached file" do
      obj = subject.load_script

      obj.should_not be_nil
      obj.class.should == script_class
    end

    it "should cache the loaded object along with the cached file" do
      obj = script_class.first(:script_path => subject)
      
      obj.should_not be_nil
    end

    it "should be able to load the cached object" do
      subject.cached_script.should_not be_nil
      subject.cached_script.class.should == script_class
    end

    it "should call the cache method before saving the new object" do
      subject.cached_script.name.should == 'cached'
    end

    it "should delete the cached object along with the cached file" do
      subject.destroy

      script_class.first(:script_path => subject).should be_nil
    end
  end

  describe "failed cached files" do
    let(:syntax_error) { repo.find_script('failures/syntax_errors.rb') }
    let(:load_error) { repo.find_script('failures/load_errors.rb') }
    let(:name_error) { repo.find_script('failures/name_errors.rb') }
    let(:no_method_error) { repo.find_script('failures/no_method_errors.rb') }
    let(:exception) { repo.find_script('failures/exceptions.rb') }
    let(:validation_error) { repo.find_script('failures/validation_errors.rb') }

    it "should not save new cached files that raised exceptions" do
      syntax_error.should_not be_saved
      load_error.should_not be_saved
      exception.should_not be_saved
    end

    pending "https://github.com/ronin-ruby/ronin/issues/7" do
      it "should not save new cached files that contain validation errors" do
        validation_error.should_not be_saved
      end
    end

    it "should store syntax errors" do
      syntax_error.cache_exception.should_not be_nil
      syntax_error.cache_exception.class.should == SyntaxError
    end

    it "should store LoadError exceptions" do
      load_error.cache_exception.should_not be_nil
      load_error.cache_exception.class.should == LoadError
    end

    it "should store NameError exceptions" do
      name_error.cache_exception.should_not be_nil
      name_error.cache_exception.class.should == NameError
    end

    it "should store NoMethodError exceptions" do
      no_method_error.cache_exception.should_not be_nil
      no_method_error.cache_exception.class.should == NoMethodError
    end

    it "should store Exceptions raised when creating the fresh object" do
      exception.cache_exception.should_not be_nil
    end

    it "should store validation errors" do
      validation_error.cache_errors.should_not be_nil
    end
  end

  describe "unmodified cached file" do
    subject { repo.find_script('cached/unmodified.rb') }

    it "should not have updated code" do
      should_not be_updated
    end

    it "should not re-cache unmodified files" do
      subject.sync.should == false
    end

    it "should not have cache errors" do
      subject.cache_errors.should be_nil
    end
  end

  describe "modified cached file" do
    subject { repo.find_script('cached/modified.rb') }

    before(:all) do
      subject.update(:timestamp => (subject.timestamp - 10))
    end

    it "should not have updated code" do
      should be_updated
    end

    it "should re-cache modified files" do
      subject.sync.should == true
    end

    it "should not have cache errors" do
      subject.cache_errors.should be_nil
    end
  end

  describe "missing cached file" do
    subject { repo.find_script('cached/missing.rb') }

    before(:all) do
      subject.update(:path => File.join('','missing','file.rb'))

      subject.sync
    end

    it "should delete the cached files" do
      described_class.count(:id => subject.id).should == 0
    end

    it "should delete cached objects for missing files" do
      script_class.count(:script_path => subject).should == 0
    end
  end
end
