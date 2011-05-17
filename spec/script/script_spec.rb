require 'spec_helper'
require 'classes/my_script'
require 'helpers/repositories'

require 'ronin/script'

describe Script do
  include Helpers::Repositories

  subject { MyScript }

  let(:repo) { repository('scripts') }

  before(:all) { repo.cache_scripts! }

  it "should be a Model" do
    subject.included_modules.should include(Model)
  end

  it "should have a name" do
    subject.included_modules.should include(Model::HasName)
  end

  it "should have a description" do
    subject.included_modules.should include(Model::HasDescription)
  end

  it "should have a version" do
    subject.included_modules.should include(Model::HasVersion)
  end

  it "should include ObjectLoader" do
    subject.included_modules.should include(ObjectLoader)
  end

  it "should include DataPaths::Finders" do
    subject.included_modules.should include(DataPaths::Finders)
  end

  it "should include Parameters" do
    subject.included_modules.should include(Parameters)
  end

  it "should include UI::Output::Helpers" do
    subject.included_modules.should include(UI::Output::Helpers)
  end

  it "should add the type property to the model" do
    subject.properties.should be_named(:type)
  end

  it "should add a relation between Script::Path and the script" do
    subject.relationships.should be_named(:script_path)
  end

  describe "#initialize" do
    it "should initialize attributes" do
      resource = subject.new(:name => 'test')

      resource.name.should == 'test'
    end

    it "should initialize parameters" do
      resource = subject.new(:x => 5)

      resource.x.should == 5
    end

    it "should allow custom initialize methods" do
      resource = subject.new

      resource.var.should == 2
    end
  end

  it "should have an script-type" do
    resource = subject.new

    resource.script_type.should == 'MyScript'
  end

  describe "load_from" do
    let(:path) { repo.find_script('my_scripts/test.rb').path }

    subject { Script.load_from(path) }

    it "should have a script_path resource" do
      subject.script_path.should_not be_nil
    end

    it "should prepare the object to be cached" do
      subject.content.should == 'this is a test'
    end

    it "should preserve instance variables" do
      subject.var.should == 2
    end

    it "should preserve instance methods" do
      subject.greeting.should == 'hello'
    end

    it "should load the script source" do
      subject.should be_script_loaded
    end
  end

  context "when previously cached" do
    subject { MyScript.first(:name => 'test') }

    it "should have a cached_file resource" do
      subject.script_path.should_not be_nil
    end

    it "should be able to load the script source" do
      subject.load_script!

      subject.greeting.should == 'hello'
    end

    it "should only load the script source once" do
      subject.load_script!

      subject.var = false
      subject.load_script!

      subject.var.should == false
    end
  end
end
