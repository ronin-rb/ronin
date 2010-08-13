require 'spec_helper'
require 'ronin/support/inflector'

describe Ronin::Support::Inflector do
  it "should not be nil" do
    subject.should_not be_nil
  end

  it "should support pluralizing words" do
    subject.pluralize('word').should == 'words'
  end

  it "should support singularizing words" do
    subject.singularize('words').should == 'word'
  end

  it "should support humanizing words" do
    subject.humanize('word_id').should == 'Word'
  end
end
