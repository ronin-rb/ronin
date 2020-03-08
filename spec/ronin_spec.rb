require 'spec_helper'
require 'ronin/ronin'
require 'ronin/version'

describe Ronin do
  it "should have a version" do
    version = subject.const_get('VERSION')

    expect(version).not_to be_nil
    expect(version).not_to be_empty
  end

  it "should include AutoLoad" do
    expect(subject).to include(AutoLoad)
  end

  it "should add a const_missing method when included" do
    base_class = Class.new
    base_class.send :include, subject

    subject.const_set('SOME_CONSTANT',1)

    expect(base_class.const_get('SOME_CONSTANT')).to eq(1)
  end
end
