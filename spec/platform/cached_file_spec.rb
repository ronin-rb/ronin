require 'ronin/platform/cached_file'

require 'spec_helper'

describe Cacheable::CachedFile do
  describe "new files" do
    before(:all) do
      Cacheable::CachedFile.auto_migrate!
      CacheableModel.auto_migrate!

      FileUtils.cp Helpers::CACHEABLE_FILE, Helpers::CACHEABLE_PATH

      @file = Cacheable::CachedFile.cache(Helpers::CACHEABLE_PATH)
    end

    it "should be able to cache new files" do
      @file.should_not be_nil
    end

    it "should cache the first cacheable object from new files" do
      @file.cached_object.should_not be_nil
      @file.cached_object.id.should == 1
    end

    it "should call the cache method before saving the new object" do
      @file.cached_object.content.should == 'this is a test'
    end
  end

  describe "unmodified files" do
    before(:all) do
      Cacheable::CachedFile.auto_migrate!
      CacheableModel.auto_migrate!

      @file = Cacheable::CachedFile.cache(Helpers::CACHEABLE_PATH)
    end

    it "should not re-cache unmodified files" do
      @file.sync.should == false
    end
  end

  describe "modified files" do
    before(:all) do
      Cacheable::CachedFile.auto_migrate!
      CacheableModel.auto_migrate!

      @file = Cacheable::CachedFile.cache(Helpers::CACHEABLE_PATH)
      @file.timestamp = Time.at(@file.timestamp - 10)
      @file.save
    end

    it "should re-cache modified files" do
      @file.sync.should == true
    end
  end

  describe "cached files" do
    before(:all) do
      Cacheable::CachedFile.auto_migrate!
      CacheableModel.auto_migrate!

      @file = Cacheable::CachedFile.cache(Helpers::CACHEABLE_FILE)
    end

    it "should have a path" do
      @file.path.should_not be_nil
    end

    it "should have a timestamp" do
      @file.timestamp.should_not be_nil
    end

    it "should have the model name of the cached object" do
      @file.model_name.should == 'CacheableModel'
    end

    it "should be able to load the Model of the cached object" do
      @file.cached_model.should == CacheableModel
    end

    it "should delete the cached object along with the cached file" do
      @file = Cacheable::CachedFile.first
      @file.destroy

      CacheableModel.first.should be_nil
    end
  end

  describe "missing files" do
    before(:all) do
      Cacheable::CachedFile.auto_migrate!
      CacheableModel.auto_migrate!

      @file = Cacheable::CachedFile.cache(Helpers::CACHEABLE_PATH)

      FileUtils.rm Helpers::CACHEABLE_PATH

      @file.sync
    end

    it "should delete the cached files" do
      Cacheable::CachedFile.first.should be_nil
    end

    it "should delete cached objects for missing files" do
      CacheableModel.first.should be_nil
    end
  end
end
