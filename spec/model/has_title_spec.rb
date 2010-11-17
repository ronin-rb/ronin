require 'model/spec_helper'
require 'model/models/titled_model'

require 'ronin/model/has_title'

describe Model::HasTitle do
  subject { TitledModel }

  before(:all) do
    subject.auto_migrate!
  end

  it "should define a title property" do
    subject.properties.should be_named(:title)
  end

  it "should be able to find resources with similar titles" do
    subject.create!(:title => 'Foo one')
    subject.create!(:title => 'Foo bar two')

    models = subject.titled('Foo')

    models.length.should == 2
    models[0].title.should == 'Foo one'
    models[1].title.should == 'Foo bar two'
  end
end
