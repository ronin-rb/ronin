require 'spec_helper'
require 'platform/spec_helper'
require 'platform/classes/cacheable_model'

require 'ronin/platform/cacheable'

describe Platform::Cacheable do
  before(:all) do
    @overlay = load_overlay('test1')
    @overlay.cache_files!
  end

  it "should add the type property to the model" do
    CacheableModel.properties.should be_named(:type)
  end

  it "should add a relation between Platform::CachedFile and the model" do
    CacheableModel.relationships.should have_key(:cached_file)
  end

  it "should add the class to Cacheable.models" do
    Platform::Cacheable.models.should include(CacheableModel)
  end

  describe "load_from" do
    before(:all) do
      @path = @overlay.cached_files.first.path
      @obj = Platform::Cacheable.load_from(@path)
    end

    it "should have a cached_file resource" do
      @obj.cached_file.should_not be_nil
    end

    it "should have a cache_path" do
      @obj.cache_path.should == @path
    end

    it "should prepare the object to be cached" do
      @obj.content.should == 'this is test one'
    end

    it "should preserve instance variables" do
      @obj.var.should == 1
    end

    it "should preserve instance methods" do
      @obj.greeting.should == 'hello'
    end

    it "should load the original code" do
      @obj.should be_original_loaded
    end
  end

  describe "cached" do
    before(:each) do
      @model = CacheableModel.first
    end

    it "should be able to load the original object" do
      @model.load_original!

      @model.greeting.should == 'hello'
    end

    it "should load the original object on demand" do
      @model.greeting.should == 'hello'
    end

    it "should only load the original object once" do
      @model.load_original!

      @model.var = false
      @model.load_original!

      @model.var.should == false
    end
  end
end
