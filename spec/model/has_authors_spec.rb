require 'model/spec_helper'
require 'model/models/authored_model'

require 'ronin/model/has_authors'

describe Model::HasAuthors do
  subject { AuthoredModel }

  before(:all) do
    subject.auto_migrate!

    resource = subject.new
    resource.author(
      :name => 'Alice',
      :email => 'alice@example.com',
      :organization => 'Crew'
    )

    resource.save
  end

  it "should include Ronin::Model" do
    subject.ancestors.should include(Model)
  end

  it "should define an authors relationship" do
    relationship = subject.relationships['authors']

    relationship.should_not be_nil
    relationship.child_model.should == Author
  end

  it "should define relationships with Author" do
    relationship = Author.relationships['authored_models']
    
    relationship.should_not be_nil
    relationship.child_model.should == subject
  end

  it "should allow adding authors to a resource" do
    resource = subject.new
    resource.author(:name => 'Alice', :email => 'alice@example.com')

    resource.authors.should_not be_empty
  end

  it "should allow querying resources based on their Author" do
    resources = subject.written_by('Alice')

    resources.length.should == 1
    resources[0].author.name.should == 'Alice'
  end

  it "should allow querying resources based on their Organization" do
    resources = subject.written_for('Crew')

    resources.length.should == 1
    resources[0].author.organization.should == 'Crew'
  end
end
