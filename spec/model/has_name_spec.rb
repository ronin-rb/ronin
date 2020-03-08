require 'spec_helper'
require 'model/models/named_model'

require 'ronin/model/has_name'

describe Model::HasName do
  subject { NamedModel }

  before(:all) { subject.auto_migrate! }

  it "should include Ronin::Model" do
    expect(subject.ancestors).to include(Model)
  end

  it "should define a name property" do
    expect(subject.properties).to be_named(:name)
  end

  it "should require a name" do
    resource = subject.new
    expect(resource).not_to be_valid

    resource.name = 'foo'
    expect(resource).to be_valid
  end

  it "should be able to find resources with similar names" do
    subject.create!(:name => 'foo1')
    subject.create!(:name => 'foo2')

    resources = subject.named('foo')

    expect(resources.length).to eq(2)
    expect(resources[0].name).to eq('foo1')
    expect(resources[1].name).to eq('foo2')
  end
end
