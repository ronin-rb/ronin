require 'spec_helper'
require 'ronin/model/model'

require 'model/models/basic_model'
require 'model/models/custom_model'

describe Model do
  subject { BasicModel }

  let(:custom_model) { CustomModel }

  before(:all) do
    subject.auto_migrate!
  end

  it "should have a default repository name" do
    subject.default_repository_name.should == :default
  end

  it "should allow creating new instances of the model" do
    resource = subject.new(:name => 'joe')

    resource.name.should == 'joe'
  end

  it "should call initialize when creating new instances of the model" do
    resource = custom_model.new(:name => 'joe')

    resource.name.should == 'joe'
    resource.var.should == 2
  end

  it "should call initialize when creating a new resource" do
    resource = custom_model.create!(:name => 'jim')

    resource.name.should == 'jim'
    resource.var.should == 2
  end

  it "should call initialize when loading from the database" do
    custom_model.create!(:name => 'bob')

    resource = custom_model.first(:name => 'bob')
    resource.name.should == 'bob'
    resource.var.should == 2
  end

  describe "humanize_attributes" do
    let(:resource) { subject.new(:name => 'joe', :age => 21) }

    it "should humanize the attributes of a model" do
      resource.humanize_attributes.should == {
        'Name' => 'joe',
        'Age' => '21'
      }
    end

    it "should exclude certain attributes to humanize" do
      resource.humanize_attributes(:exclude => [:name]).should == {
        'Age' => '21'
      }
    end

    it "should filter out nil values" do
      resource.age = nil

      resource.humanize_attributes.should == {'Name' => 'joe'}
    end

    it "should filter out empty values" do
      resource.name = ''

      resource.humanize_attributes.should == {'Age' => '21'}
    end
  end
end
