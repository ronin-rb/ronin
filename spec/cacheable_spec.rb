require 'ronin/cacheable'

require 'spec_helper'
require 'classes/cacheable_model'
require 'helpers/cacheable'

describe Cacheable do
  before(:all) do
    CacheableModel.auto_migrate!
  end

  it "should maintain a list of models which are cacheable" do
    Cacheable.models.include?(CacheableModel).should == true
  end

  it "should be able to load arbitrary objects from a file" do
    objs = Cacheable.load_all_from(CACHEABLE_FILE)

    objs.length.should == 1
    objs.first.content.should == 'this is a test'
  end

  it "should be able to cache arbitrary objects from a file" do
    objs = Cacheable.cache_all(CACHEABLE_FILE)

    objs.length.should == 1
    objs.first.content.should == 'this is a test'
  end

  describe "load_from" do
    before(:all) do
      CacheableModel.auto_migrate!

      @obj = CacheableModel.load_from(CACHEABLE_FILE)
    end

    it "should set the cached_path property" do
      @obj.cached_path.should == Pathname.new(CACHEABLE_FILE)
    end

    it "should set the cached_timestamp property" do
      @obj.cached_timestamp.should == File.mtime(CACHEABLE_FILE).to_i
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
  end

  describe "new files" do
    before(:all) do
      CacheableModel.auto_migrate!
      FileUtils.cp CACHEABLE_FILE, CACHEABLE_PATH
    end

    it "should be able to cache new files" do
      obj = CacheableModel.cache(CACHEABLE_PATH)

      obj.should_not be_dirty
      obj.id.should == 1
    end

    it "should call the cache method before saving the new object" do
      model = CacheableModel.first

      model.content.should == 'this is a test'
    end
  end

  describe "unmodified files" do
    before(:all) do
      CacheableModel.auto_migrate!
      CacheableModel.cache(CACHEABLE_PATH)
    end

    it "should not re-cache unmodified files" do
      model = CacheableModel.first

      (model.sync!).should == false
    end
  end

  describe "modified files" do
    before(:all) do
      CacheableModel.auto_migrate!

      model = CacheableModel.cache(CACHEABLE_PATH)
      model.cached_timestamp -= 10
      model.save
    end

    it "should re-cache modified files" do
      model = CacheableModel.first

      (model.sync!).should == true
    end
  end

  describe "cached files" do
    before(:all) do
      CacheableModel.auto_migrate!
      CacheableModel.cache(CACHEABLE_FILE)
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

  describe "missing files" do
    before(:all) do
      CacheableModel.auto_migrate!
      CacheableModel.cache(CACHEABLE_PATH)

      FileUtils.rm CACHEABLE_PATH
    end

    it "should be able to expunge cached objects for missing files" do
      CacheableModel.first.sync!

      CacheableModel.all(:cached_path => CACHEABLE_PATH).should be_empty
    end
  end
end
