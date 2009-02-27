require 'ronin/static'

require 'spec_helper'
require 'static/helpers/static'

describe Static do
  it "should list static directories" do
    STATIC_DIRS.each do |dir|
      Static.static_dirs.include?(dir).should == true
    end
  end
end
