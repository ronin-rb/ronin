require 'model/spec_helper'
require 'model/models/cacheable_model'
require 'helpers/repositories'

require 'ronin/model/cacheable'

describe Model::Cacheable do
  include Helpers::Repositories

  let(:repo) { repository('test1') }
  let(:cacheable_model) { CacheableModel }

  before(:all) do
    repo.cache_files!
  end

  it "should add the type property to the model" do
    cacheable_model.properties.should be_named(:type)
  end

  it "should add a relation between CachedFile and the model" do
    cacheable_model.relationships.should have_key(:cached_file)
  end

  it "should add the class to Cacheable.models" do
    Model::Cacheable.models.should include(cacheable_model)
  end

  describe "load_from" do
    let(:path) { repo.cached_files.first.path }

    subject { Model::Cacheable.load_from(path) }

    it "should have a cached_file resource" do
      subject.cached_file.should_not be_nil
    end

    it "should have a cache_path" do
      subject.cache_path.should == path
    end

    it "should prepare the object to be cached" do
      subject.content.should == 'this is test one'
    end

    it "should preserve instance variables" do
      subject.var.should == 1
    end

    it "should preserve instance methods" do
      subject.greeting.should == 'hello'
    end

    it "should load the original code" do
      subject.should be_original_loaded
    end
  end

  describe "cached" do
    subject { CacheableModel.first }

    it "should have a cached_file resource" do
      subject.cached_file.should_not be_nil
    end

    it "should have a cache_path" do
      subject.cache_path.should be_file
    end

    it "should load the context block" do
      subject.class.load_context_block(subject.cache_path).should_not be_nil
    end

    it "should be able to load the original object" do
      subject.load_original!

      subject.greeting.should == 'hello'
    end

    it "should load the original object on demand" do
      subject.greeting.should == 'hello'
    end

    it "should only load the original object once" do
      subject.load_original!

      subject.var = false
      subject.load_original!

      subject.var.should == false
    end
  end
end
