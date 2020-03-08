require 'spec_helper'
require 'model/models/titled_model'

require 'ronin/model/has_title'

describe Model::HasTitle do
  subject { TitledModel }

  before(:all) { subject.auto_migrate! }

  it "should include Ronin::Model" do
    expect(subject.ancestors).to include(Model)
  end

  it "should define a title property" do
    expect(subject.properties).to be_named(:title)
  end

  it "should be able to find resources with similar titles" do
    subject.create!(:title => 'Foo one')
    subject.create!(:title => 'Foo bar two')

    resources = subject.titled('Foo')

    expect(resources.length).to eq(2)
    expect(resources[0].title).to eq('Foo one')
    expect(resources[1].title).to eq('Foo bar two')
  end
end
