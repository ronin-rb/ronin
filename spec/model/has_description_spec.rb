require 'spec_helper'
require 'ronin/model/has_description'

require 'model/models/described_model'

describe Model::HasDescription do
  before(:all) do
    DescribedModel.auto_migrate!
  end

  it "should define a description property" do
    property = DescribedModel.properties['description']

    property.should_not be_nil
  end

  describe "description" do
    before(:each) do
      @model = DescribedModel.new
    end

    it "should allow the setting of the description" do
      @model.description = 'test one'
      @model.description.should == 'test one'
    end

    it "should strip leading and tailing white-space" do
      @model.description = %{   test two    }

      @model.description.should == 'test two'
    end

    it "should strip leading and tailing white-space from each line" do
      @model.description = %{
        test
        three
      }

      @model.description.should == "test\nthree"
    end

    it "should preserve non-bordering empty lines" do
      @model.description = %{
        test

        four
      }

      @model.description.should == "test\n\nfour"
    end
  end

  it "should be able to find resources with similar descriptions" do
    DescribedModel.create!(:description => 'foo one')
    DescribedModel.create!(:description => 'foo bar two')

    models = DescribedModel.describing('foo')
    models.length.should == 2
    models[0].description.should == 'foo one'
    models[1].description.should == 'foo bar two'
  end
end
