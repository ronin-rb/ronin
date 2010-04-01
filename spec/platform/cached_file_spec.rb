require 'ronin/platform/cached_file'

require 'spec_helper'
require 'helpers/database'
require 'platform/classes/cacheable_model'
require 'platform/helpers/overlays'

describe Platform::CachedFile do
  include Helpers::Overlays

  before(:all) do
    @overlay = load_overlay('test1')
  end

  describe "cached file" do
    before(:all) do
      @overlay.cache_files!

      @cached_file = @overlay.cached_files.first
    end

    it "should have a path" do
      @cached_file.path.should_not be_nil
    end

    it "should have a timestamp" do
      @cached_file.timestamp.should_not be_nil
    end

    it "should not have updated code" do
      @cached_file.should_not be_updated
    end

    it "should not have cache exceptions" do
      @cached_file.cache_exception.should be_nil
    end

    it "should not have cache errors" do
      @cached_file.cache_errors.should be_nil
    end

    it "should have the model name of the cached object" do
      @cached_file.model_name.should == 'CacheableModel'
    end

    it "should have the model path of the cached object" do
      @cached_file.model_path.should == 'cacheable_model'
    end

    it "should be able to load the Model of the cached object" do
      @cached_file.cached_model.should == CacheableModel
    end

    it "should be able to load a fresh model from the cached file" do
      obj = @cached_file.fresh_object

      obj.should_not be_nil
      obj.class.should == CacheableModel
    end

    it "should lazy-upgrade the cached model before loading the fresh object" do
      obj = @cached_file.fresh_object

      obj.class.should be_auto_upgraded
    end

    it "should cache the loaded object along with the cached file" do
      obj = CacheableModel.first(:cached_file => @cached_file)
      
      obj.should_not be_nil
    end

    it "should be able to load the cached object" do
      @cached_file.cached_object.should_not be_nil
      @cached_file.cached_object.class.should == CacheableModel
    end

    it "should call the cache method before saving the new object" do
      @cached_file.cached_object.content.should == 'this is test one'
    end

    it "should delete the cached object along with the cached file" do
      @cached_file.destroy

      CacheableModel.first(:cached_file => @cached_file).should be_nil
    end
  end

  describe "unmodified cached file" do
    before(:all) do
      @overlay.cache_files!

      @cached_file = @overlay.cached_files.first
    end

    it "should not have updated code" do
      @cached_file.should_not be_updated
    end

    it "should not re-cache unmodified files" do
      @cached_file.sync.should == false
    end

    it "should not have cache errors" do
      @cached_file.cache_errors.should be_nil
    end
  end

  describe "modified cached file" do
    before(:all) do
      @overlay.cache_files!

      @cached_file = @overlay.cached_files.first
      @cached_file.timestamp -= 10
      @cached_file.save
    end

    it "should not have updated code" do
      @cached_file.should be_updated
    end

    it "should re-cache modified files" do
      @cached_file.sync.should == true
    end

    it "should not have cache errors" do
      @cached_file.cache_errors.should be_nil
    end
  end

  describe "missing cached file" do
    before(:all) do
      @overlay.cache_files!

      @cached_file = @overlay.cached_files.first
      @cached_file.path = File.join('','missing','file.rb')
      @cached_file.sync
    end

    it "should delete the cached files" do
      Platform::CachedFile.count(:id => @cached_file.id).should == 0
    end

    it "should delete cached objects for missing files" do
      CacheableModel.count(:cached_file => @cached_file).should == 0
    end
  end
end
