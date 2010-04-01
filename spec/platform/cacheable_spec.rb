require 'ronin/platform/cacheable'

require 'spec_helper'
require 'platform/classes/cacheable_model'
require 'platform/helpers/overlays'

describe Platform::Cacheable do
  include Helpers::Overlays

  before(:all) do
    @overlay = load_overlay('test1')
    @overlay.save_cached_files!
  end

  describe "load_from" do
    before(:all) do
      @path = @overlay.cached_files.first.path
      @obj = CacheableModel.load_from(@path)
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
