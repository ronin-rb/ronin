require 'ronin/ronin'
require 'ronin/version'

require 'spec_helper'

describe Ronin do
  it "should have a version" do
    @version = Ronin.const_get('VERSION')
    @version.should_not be_nil
    @version.should_not be_empty
  end

  it "should be able to find files within Ronin" do
    Ronin.find_files(File.join('lib','ronin','version.rb')).should_not be_empty
  end
end
