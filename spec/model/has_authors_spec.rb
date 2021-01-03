require 'spec_helper'
require 'model/models/authored_model'

require 'ronin/model/has_authors'

describe Model::HasAuthors do
  subject { AuthoredModel }

  before(:all) do
    resource = subject.new(:content => 'Test')
    resource.author(
      :name => 'Alice',
      :email => 'alice@example.com',
      :organization => 'Crew'
    )

    resource.save
  end

  describe ".included" do
    it "should include Ronin::Model" do
      expect(subject.ancestors).to include(Model)
    end

    it "should define an authors relationship" do
      relationship = subject.relationships['authors']

      expect(relationship).not_to be_nil
      expect(relationship.child_model).to eq(Author)
    end

    it "should define relationships with Author" do
      relationship = Author.relationships['authored_models']

      expect(relationship).not_to be_nil
      expect(relationship.child_model).to eq(subject)
    end
  end

  describe "#author" do
    it "should allow adding authors to a resource" do
      resource = subject.new
      resource.author(:name => 'Alice', :email => 'alice@example.com')

      expect(resource.authors).not_to be_empty
    end
  end

  describe ".written_by" do
    it "should allow querying resources based on their Author" do
      resources = subject.written_by('Alice')

      expect(resources.length).to eq(1)
      expect(resources[0].authors[0].name).to eq('Alice')
    end

    it "should allow querying resources based on their Organization" do
      resources = subject.written_for('Crew')

      expect(resources.length).to eq(1)
      expect(resources[0].authors[0].organization).to eq('Crew')
    end
  end
end
