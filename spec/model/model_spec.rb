require 'spec_helper'
require 'model/models/basic_model'
require 'model/models/custom_model'

require 'ronin/model/model'

describe Model do
  subject { BasicModel }

  let(:custom_model) { CustomModel }

  before(:all) { subject.auto_migrate! }

  it "should have a default repository name" do
    expect(subject.default_repository_name).to eq(:default)
  end

  it "should allow creating new instances of the model" do
    resource = subject.new(:name => 'joe')

    expect(resource.name).to eq('joe')
  end

  it "should call initialize when creating new instances of the model" do
    resource = custom_model.new(:name => 'joe')

    expect(resource.name).to eq('joe')
    expect(resource.var).to eq(2)
  end

  it "should call initialize when creating a new resource" do
    resource = custom_model.create!(:name => 'jim')

    expect(resource.name).to eq('jim')
    expect(resource.var).to eq(2)
  end

  it "should call initialize when loading from the database" do
    custom_model.create!(:name => 'bob')

    resource = custom_model.first(:name => 'bob')
    expect(resource.name).to eq('bob')
    expect(resource.var).to eq(2)
  end

  describe "humanize_attributes" do
    let(:resource) { subject.new(:name => 'joe', :age => 21) }

    it "should humanize the attributes of a model" do
      expect(resource.humanize_attributes).to eq({
        'Name' => 'joe',
        'Age' => '21'
      })
    end

    it "should exclude certain attributes to humanize" do
      expect(resource.humanize_attributes(:exclude => [:name])).to eq({
        'Age' => '21'
      })
    end

    it "should filter out nil values" do
      resource.age = nil

      expect(resource.humanize_attributes).to eq({'Name' => 'joe'})
    end

    it "should filter out empty values" do
      resource.name = ''

      expect(resource.humanize_attributes).to eq({'Age' => '21'})
    end
  end
end
