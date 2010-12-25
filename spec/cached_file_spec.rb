require 'spec_helper'
require 'helpers/repositories'
require 'model/models/cacheable_model'

require 'ronin/cached_file'

describe CachedFile do
  include Helpers::Repositories

  let(:test1) { repository('test1') }
  let(:test2) { repository('test2') }

  let(:cacheable_model) { CacheableModel }

  before(:all) do
    test1.cache_files!
    test2.cache_files!
  end

  describe "cached file" do
    subject { test1.cached_files.first }

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
      subject.model_name.should == cacheable_model.name
    end

    it "should have the model path of the cached object" do
      subject.model_path.should == 'cacheable_model'
    end

    it "should be able to load the Model of the cached object" do
      subject.cached_model.should == cacheable_model
    end

    it "should be able to load a fresh model from the cached file" do
      obj = subject.fresh_object

      obj.should_not be_nil
      obj.class.should == cacheable_model
    end

    it "should cache the loaded object along with the cached file" do
      obj = cacheable_model.first(:cached_file => subject)
      
      obj.should_not be_nil
    end

    it "should be able to load the cached object" do
      subject.cached_object.should_not be_nil
      subject.cached_object.class.should == cacheable_model
    end

    it "should call the cache method before saving the new object" do
      subject.cached_object.content.should == 'this is test one'
    end

    it "should delete the cached object along with the cached file" do
      subject.destroy

      cacheable_model.first(:cached_file => subject).should be_nil
    end
  end

  describe "failed cached files" do
    let(:syntax_error) do
      test2.cached_files.find do |cached_file|
        cached_file.path.basename == Pathname.new('syntax_errors.rb')
      end
    end

    let(:load_error) do
      test2.cached_files.find do |cached_file|
        cached_file.path.basename == Pathname.new('load_errors.rb')
      end
    end

    let(:no_method_error) do
      test2.cached_files.find do |cached_file|
        cached_file.path.basename == Pathname.new('no_method_errors.rb')
      end
    end

    let(:exception) do
      test2.cached_files.find do |cached_file|
        cached_file.path.basename == Pathname.new('exceptions.rb')
      end
    end

    let(:validation_error) do
      test2.cached_files.find do |cached_file|
        cached_file.path.basename == Pathname.new('validation_errors.rb')
      end
    end

    it "should not save new cached files that raised exceptions" do
      syntax_error.should_not be_saved
      load_error.should_not be_saved
      exception.should_not be_saved
    end

    it "should not save new cached files that contain validation errors" do
      validation_error.should_not be_saved
    end

    it "should store syntax errors" do
      syntax_error.cache_exception.should_not be_nil
      syntax_error.cache_exception.class.should == SyntaxError
    end

    it "should store LoadError exceptions" do
      load_error.cache_exception.should_not be_nil
      load_error.cache_exception.class.should == LoadError
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
    subject { test1.cached_files.first }

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
    subject do
      test1.reload

      cached_file = test1.cached_files.first
      cached_file.update(:timestamp => (cached_file.timestamp - 10))

      cached_file
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
    subject do
      test1.reload

      cached_file = test1.cached_files.first
      cached_file.update(:path => File.join('','missing','file.rb'))
      cached_file.sync

      cached_file
    end

    it "should delete the cached files" do
      CachedFile.count(:id => subject.id).should == 0
    end

    it "should delete cached objects for missing files" do
      cacheable_model.count(:cached_file => subject).should == 0
    end
  end
end
