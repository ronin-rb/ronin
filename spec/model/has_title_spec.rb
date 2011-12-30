require 'spec_helper'
require 'model/models/titled_model'

require 'ronin/model/has_title'

describe Model::HasTitle do
  subject { TitledModel }

  before(:all) { subject.auto_migrate! }

  it "should include Ronin::Model" do
    subject.ancestors.should include(Model)
  end

  it "should define a title property" do
    subject.properties.should be_named(:title)
  end

  it "should be able to find resources with similar titles" do
    subject.create!(:title => 'Foo one')
    subject.create!(:title => 'Foo bar two')

    resources = subject.titled('Foo')

    resources.length.should == 2
    resources[0].title.should == 'Foo one'
    resources[1].title.should == 'Foo bar two'
  end
end
