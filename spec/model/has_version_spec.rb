require 'spec_helper'
require 'model/models/versioned_model'

require 'ronin/model/has_version'

describe Model::HasVersion do
  subject { VersionedModel }

  before(:all) do
    subject.auto_migrate!

    subject.create(
      :version => '1.1',
      :content => 'Foo'
    )

    subject.create(
      :version => '1.1',
      :content => 'Bar'
    )

    subject.create(
      :version => '1.2',
      :content => 'Foo'
    )
  end

  it "should include Ronin::Model" do
    expect(subject.ancestors).to include(Model)
  end

  it "should define a version property" do
    expect(subject.properties).to be_named(:version)
  end

  it "should default the version property to '1.0'" do
    resource = subject.new

    expect(resource.version).to eq('0.1')
  end

  it "should allow querying specific revisions" do
    resources = subject.revision('1.1')

    expect(resources.length).to eq(2)
    expect(resources[0].version).to eq('1.1')
    expect(resources[0].content).to eq('Foo')

    expect(resources[1].version).to eq('1.1')
    expect(resources[1].content).to eq('Bar')
  end

  it "should allow querying the latest revision" do
    resource = subject.all(:content => 'Foo').latest

    expect(resource.version).to eq('1.2')
  end
end
