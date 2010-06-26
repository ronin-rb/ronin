require 'spec_helper'
require 'ronin/support/inflector'

describe Ronin::Support::Inflector do
  it "should not be nil" do
    Ronin::Support.const_get(:Inflector).should_not be_nil
  end

  it "should support pluralizing words" do
    Ronin::Support::Inflector.pluralize('word').should == 'words'
  end

  it "should support singularizing words" do
    Ronin::Support::Inflector.singularize('words').should == 'word'
  end

  it "should support humanizing words" do
    Ronin::Support::Inflector.humanize('word_id').should == 'Word'
  end
end
