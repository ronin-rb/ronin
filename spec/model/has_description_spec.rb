require 'ronin/model/has_description'

require 'spec_helper'
require 'model/classes/described_model'

describe Model::HasDescription do
  before(:each) do
    @model = DescribedModel.new
  end

  it "should allow the setting of the description" do
    @model.description = 'test one'
    @model.description.should == 'test one'
  end

  it "should strip leading and tailing white-space" do
    @model.description = %{
test two
    }

    @model.description.should == 'test two'
  end

  it "should strip leading and tailing white-space from each line" do
    @model.description = %{
      test
      three
    }

    @model.description.should == "test\nthree"
  end
end
