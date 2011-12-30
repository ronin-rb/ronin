require 'spec_helper'
require 'model/models/named_model'

require 'ronin/model/has_name'

describe Model::HasName do
  subject { NamedModel }

  before(:all) { subject.auto_migrate! }

  it "should include Ronin::Model" do
    subject.ancestors.should include(Model)
  end

  it "should define a name property" do
    subject.properties.should be_named(:name)
  end

  it "should require a name" do
    resource = subject.new
    resource.should_not be_valid

    resource.name = 'foo'
    resource.should be_valid
  end

  it "should be able to find resources with similar names" do
    subject.create!(:name => 'foo1')
    subject.create!(:name => 'foo2')

    resources = subject.named('foo')

    resources.length.should == 2
    resources[0].name.should == 'foo1'
    resources[1].name.should == 'foo2'
  end
end
