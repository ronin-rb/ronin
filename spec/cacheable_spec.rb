require 'ronin/cacheable'

require 'spec_helper'
require 'classes/cacheable_model'
require 'helpers/cacheable'

describe Cacheable do
  before(:all) do
    CacheableModel.auto_migrate!

    @path = File.join(Dir.tmpdir,File.basename(CACHED_PATH))
  end

  describe "new files" do
    before(:all) do
      FileUtils.cp CACHED_PATH, @path
    end

    it "should be able to cache new files" do
      CacheableModel.cache(@path).should == true
    end
  end

  describe "unmodified files" do
    it "should not re-cache unmodified files" do
      model = CacheableModel.first

      (model.sync!).should == false
    end
  end

  describe "modified files" do
    before(:all) do
      FileUtils.touch @path
    end

    it "should re-cache modified files" do
      model = CacheableModel.first

      (model.sync!).should == true
    end
  end

  describe "missing files" do
    before(:all) do
      FileUtils.rm @path
    end

    it "should be able to expunge cached objects for missing files" do
      CacheableModel.first.sync!

      CacheableModel.all(:cached_path => @path).should be_empty
    end
  end
end
