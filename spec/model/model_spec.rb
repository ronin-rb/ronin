require 'spec_helper'
require 'ronin/model/model'

require 'model/models/basic_model'
require 'model/models/custom_model'

describe Model do
  before(:all) do
    BasicModel.auto_migrate!
  end

  it "should have a default repository name" do
    BasicModel.default_repository_name.should == :default
  end

  it "should allow creating new instances of the model" do
    resource = BasicModel.new(:name => 'joe')

    resource.name.should == 'joe'
  end

  it "should call initialize when creating new instances of the model" do
    resource = CustomModel.new(:name => 'joe')

    resource.name.should == 'joe'
    resource.var.should == 2
  end

  it "should call initialize when creating a new resource" do
    resource = CustomModel.create!(:name => 'jim')

    resource.name.should == 'jim'
    resource.var.should == 2
  end

  it "should call initialize when loading from the database" do
    CustomModel.create!(:name => 'bob')

    resource = CustomModel.first(:name => 'bob')
    resource.name.should == 'bob'
    resource.var.should == 2
  end

  describe "humanize_attributes" do
    before(:all) do
      @resource = BasicModel.new(:name => 'joe', :age => 21)
    end

    it "should humanize the attributes of a model" do
      @resource.humanize_attributes.should == {
        'Name' => 'joe',
        'Age' => '21'
      }
    end

    it "should exclude certain attributes to humanize" do
      @resource.humanize_attributes(:exclude => [:name]).should == {
        'Age' => '21'
      }
    end

    it "should filter out nil values" do
      resource = BasicModel.new(:name => 'joe')

      resource.humanize_attributes.should == {'Name' => 'joe'}
    end

    it "should filter out empty values" do
      resource = BasicModel.new(:name => '', :age => 21)

      resource.humanize_attributes.should == {'Age' => '21'}
    end
  end
end
