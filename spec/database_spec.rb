require 'spec_helper'
require 'ronin/database'

describe Database do
  describe "repositories" do
    it "should not be empty" do
      subject.repositories.should_not be_empty
    end

    it "should have a ':default' repository" do
      subject.repositories[:default].should_not be_nil
    end
  end

  it "shold determine if a repository is defined" do
    subject.repository?(:default).should == true
  end

  it "should determine when a repository is setup" do
    subject.setup?(:default).should == true
  end

  it "should not allow switching to unknown repositories" do
    lambda {
      subject.repository(:foo) { }
    }.should raise_error(Database::UnknownRepository)
  end
end
