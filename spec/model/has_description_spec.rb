require 'spec_helper'
require 'model/models/described_model'

require 'ronin/model/has_description'

describe Model::HasDescription do
  subject { DescribedModel }

  before(:all) { subject.auto_migrate! }

  it "should include Ronin::Model" do
    expect(subject.ancestors).to include(Model)
  end

  it "should define a description property" do
    expect(subject.properties).to be_named(:description)
  end

  describe "#description" do
    let(:resource) { DescribedModel.new }

    it "should allow the setting of the description" do
      resource.description = 'test one'
      expect(resource.description).to eq('test one')
    end

    it "should strip leading and tailing white-space" do
      resource.description = %{   test two    }

      expect(resource.description).to eq('test two')
    end

    it "should strip leading and tailing white-space from each line" do
      resource.description = %{
        test
        three
      }

      expect(resource.description).to eq("test\nthree")
    end

    it "should preserve non-bordering empty lines" do
      resource.description = %{
        test

        four
      }

      expect(resource.description).to eq("test\n\nfour")
    end
  end

  it "should be able to find resources with similar descriptions" do
    subject.create!(:description => 'foo one')
    subject.create!(:description => 'foo bar two')

    resources = subject.describing('foo')

    expect(resources.length).to eq(2)
    expect(resources[0].description).to eq('foo one')
    expect(resources[1].description).to eq('foo bar two')
  end
end
