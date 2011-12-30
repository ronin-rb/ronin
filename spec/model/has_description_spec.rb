require 'spec_helper'
require 'model/models/described_model'

require 'ronin/model/has_description'

describe Model::HasDescription do
  subject { DescribedModel }

  before(:all) { subject.auto_migrate! }

  it "should include Ronin::Model" do
    subject.ancestors.should include(Model)
  end

  it "should define a description property" do
    subject.properties.should be_named(:description)
  end

  describe "#description" do
    let(:resource) { DescribedModel.new }

    it "should allow the setting of the description" do
      resource.description = 'test one'
      resource.description.should == 'test one'
    end

    it "should strip leading and tailing white-space" do
      resource.description = %{   test two    }

      resource.description.should == 'test two'
    end

    it "should strip leading and tailing white-space from each line" do
      resource.description = %{
        test
        three
      }

      resource.description.should == "test\nthree"
    end

    it "should preserve non-bordering empty lines" do
      resource.description = %{
        test

        four
      }

      resource.description.should == "test\n\nfour"
    end
  end

  it "should be able to find resources with similar descriptions" do
    subject.create!(:description => 'foo one')
    subject.create!(:description => 'foo bar two')

    resources = subject.describing('foo')

    resources.length.should == 2
    resources[0].description.should == 'foo one'
    resources[1].description.should == 'foo bar two'
  end
end
