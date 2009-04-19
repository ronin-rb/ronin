require 'ronin/cacheable'

require 'spec_helper'
require 'classes/cacheable_model'
require 'helpers/cacheable'

describe Cacheable do
  before(:all) do
    @path = File.join(Dir.tmpdir,File.basename(CACHED_PATH))
  end

  describe "new files" do
    before(:all) do
      CacheableModel.auto_migrate!
      FileUtils.cp CACHED_PATH, @path
    end

    it "should be able to cache new files" do
      obj = CacheableModel.cache(@path)

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
      CacheableModel.cache(@path)
    end

    it "should not re-cache unmodified files" do
      model = CacheableModel.first

      (model.sync!).should == false
    end
  end

  describe "modified files" do
    before(:all) do
      CacheableModel.auto_migrate!
      CacheableModel.cache(@path)

      sleep 1
      FileUtils.touch @path
    end

    it "should re-cache modified files" do
      model = CacheableModel.first

      (model.sync!).should == true
    end
  end

  describe "missing files" do
    before(:all) do
      CacheableModel.auto_migrate!
      CacheableModel.cache(@path)

      FileUtils.rm @path
    end

    it "should be able to expunge cached objects for missing files" do
      CacheableModel.first.sync!

      CacheableModel.all(:cached_path => @path).should be_empty
    end
  end
end
