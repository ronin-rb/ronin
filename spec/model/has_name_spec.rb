require 'ronin/model/has_name'

require 'spec_helper'
require 'model/classes/named_model'

describe Model::HasName do
  it "should require a name" do
    model = NamedModel.new
    model.should_not be_valid

    model.name = 'foo'
    model.should be_valid
  end
end
