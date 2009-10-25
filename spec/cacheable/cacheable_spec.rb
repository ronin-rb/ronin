require 'ronin/cacheable'

require 'spec_helper'
require 'cacheable/classes/cacheable_model'
require 'cacheable/helpers/cacheable'

describe Cacheable do
  describe "load_from" do
    before(:all) do
      CacheableModel.auto_migrate!

      @obj = CacheableModel.load_from(Helpers::CACHEABLE_FILE)
    end

    it "should have a cached_file resource" do
      @obj.cached_file.should_not be_nil
    end

    it "should have a cache_path" do
      @obj.cache_path.should == Helpers::CACHEABLE_FILE
    end

    it "should have a cache_dir" do
      @obj.cache_dir.should == File.dirname(Helpers::CACHEABLE_FILE)
    end

    it "should prepare the object to be cached" do
      @obj.content.should == 'this is a test'
    end

    it "should preserve instance variables" do
      @obj.config.should == true
    end

    it "should preserve instance methods" do
      @obj.greeting.should == 'hello'
    end

    it "should load the original code" do
      @obj.should be_original_loaded
    end
  end

  describe "cached" do
    before(:all) do
      Cacheable::CachedFile.auto_migrate!
      CacheableModel.auto_migrate!

      Cacheable::CachedFile.cache(Helpers::CACHEABLE_FILE)
    end

    it "should be able to load the original object" do
      model = CacheableModel.first

      model.load_original!
      model.greeting.should == 'hello'
    end

    it "should load the original object on demand" do
      model = CacheableModel.first

      model.greeting.should == 'hello'
    end

    it "should only load the original object once" do
      model = CacheableModel.first
      model.load_original!

      model.config = false
      model.load_original!

      model.config.should == false
    end
  end
end
