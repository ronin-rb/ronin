require 'spec_helper'
require 'ronin/database'

describe Database do
  describe "repositories" do
    it "should not be empty" do
      expect(subject.repositories).not_to be_empty
    end

    it "should have a ':default' repository" do
      expect(subject.repositories[:default]).not_to be_nil
    end
  end

  it "shold determine if a repository is defined" do
    expect(subject.repository?(:default)).to be(true)
  end

  it "should determine when a repository is setup" do
    expect(subject.setup?(:default)).to be(true)
  end

  it "should not allow switching to unknown repositories" do
    expect {
      subject.repository(:foo) { }
    }.to raise_error(Database::UnknownRepository)
  end
end
