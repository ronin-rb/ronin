require 'ronin/model/model'

require 'spec_helper'
require 'model/classes/test_model'

describe Model do
  before(:all) do
    TestModel.auto_migrate!
  end

  it "should have a default repository name" do
    TestModel.default_repository_name.should == Model::REPOSITORY_NAME
  end

  it "should allow creating new instances of the model" do
    resource = TestModel.new(:name => 'joe')

    resource.name.should == 'joe'
  end

  it "should call initialize when creating new instances of the model" do
    resource = TestModel.new(:name => 'joe')

    resource.var.should == 2
  end

  it "should still call initialize when loading from the database" do
    TestModel.create(:name => 'bob')

    resource = TestModel.first
    resource.var.should == 2
  end
end
