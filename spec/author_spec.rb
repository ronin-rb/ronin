require 'spec_helper'
require 'ronin/author'

describe Author do
  it "should have a String representation" do
    author = Author.new(:name => 'test')
    author.to_s.should == 'test'
  end

  describe "to_s" do
    it "should return the name when their is no email" do
      author = Author.new(:name => 'anonymous')

      author.to_s.should == 'anonymous'
    end

    it "should return the name and email when both are present" do
      author = Author.new(
        :name => 'anonymous',
        :email => 'anonymous@example.com'
      )

      author.to_s.should == 'anonymous <anonymous@example.com>'
    end
  end
end
