require 'ronin/model/has_name'

require 'spec_helper'
require 'model/models/named_model'

describe Model::HasName do
  before(:all) do
    NamedModel.auto_migrate!
  end

  it "should require a name" do
    model = NamedModel.new
    model.should_not be_valid

    model.name = 'foo'
    model.should be_valid
  end
end
