require 'model/spec_helper'
require 'model/models/named_model'

require 'ronin/model/has_name'

describe Model::HasName do
  subject { NamedModel }

  before(:all) do
    subject.auto_migrate!
  end

  it "should define a name property" do
    subject.properties.should be_named(:name)
  end

  it "should require a name" do
    model = subject.new
    model.should_not be_valid

    model.name = 'foo'
    model.should be_valid
  end

  it "should be able to find resources with similar names" do
    subject.create!(:name => 'foo1')
    subject.create!(:name => 'foo2')

    models = subject.named('foo')

    models.length.should == 2
    models[0].name.should == 'foo1'
    models[1].name.should == 'foo2'
  end
end
