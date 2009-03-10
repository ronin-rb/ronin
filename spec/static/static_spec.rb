require 'ronin/static/static'

require 'spec_helper'
require 'static/helpers/static'

describe Static do
  it "should list static directories" do
    STATIC_DIRS.each do |dir|
      Static.static_dirs.include?(dir).should == true
    end
  end

  it "should prevent the addition of non-existant directories" do
    lambda {
      Static.directory('lol')
    }.should raise_error(RuntimeError)
  end

  it "should prevent the addition of non-directories" do
    lambda {
      Static.directory(__FILE__)
    }.should raise_error(RuntimeError)
  end
end
