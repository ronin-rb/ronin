require 'spec_helper'
require 'ronin/version'

describe Ronin do
  it "should have a version" do
    version = subject.const_get('VERSION')

    expect(version).not_to be_nil
    expect(version).not_to be_empty
  end
end
