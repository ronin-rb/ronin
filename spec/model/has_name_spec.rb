require 'ronin/model/has_name'

require 'spec_helper'
require 'model/models/named_model'

describe Model::HasName do
  before(:all) do
    NamedModel.auto_migrate!
  end

  it "should define a name property" do
    property = NamedModel.properties['name']

    property.should_not be_nil
  end

  it "should require a name" do
    model = NamedModel.new
    model.should_not be_valid

    model.name = 'foo'
    model.should be_valid
  end

  it "should be able to find resources with similar names" do
    NamedModel.create!(:name => 'foo1')
    NamedModel.create!(:name => 'foo2')

    models = NamedModel.named('foo')

    models.length.should == 2
    models[0].name.should == 'foo1'
    models[1].name.should == 'foo2'
  end
end
