require 'ronin/version'

require 'spec_helper'

describe Ronin do
  it "should have a version constant" do
    @version = Ronin.const_get('VERSION')
    @version.should_not be_nil
    @version.should_not be_empty
  end
end
