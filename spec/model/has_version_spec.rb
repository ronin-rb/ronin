require 'spec_helper'
require 'ronin/model/has_version'

require 'model/models/versioned_model'

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
    subject.ancestors.should include(Model)
  end

  it "should define a version property" do
    subject.properties.should be_named(:version)
  end

  it "should default the version property to '1.0'" do
    resource = subject.new

    resource.version.should == '0.1'
  end

  it "should allow querying specific revisions" do
    resources = subject.revision('1.1')

    resources.length.should == 2
    resources[0].version.should == '1.1'
    resources[0].content.should == 'Foo'

    resources[1].version.should == '1.1'
    resources[1].content.should == 'Bar'
  end

  it "should allow querying the latest revision" do
    resource = subject.all(:content => 'Foo').latest

    resource.version.should == '1.2'
  end
end
