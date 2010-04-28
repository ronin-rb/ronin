require 'spec_helper'
require 'ronin/version'

describe Ronin do
  it "should have a version" do
    @version = Ronin.const_get('VERSION')
    @version.should_not be_nil
    @version.should_not be_empty
  end
end
