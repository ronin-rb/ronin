require 'ronin/static'

require 'spec_helper'
require 'static/helpers/static'

describe Static do
  it "should list static directories" do
    Static.static_dirs.include?(STATIC_DIR).should == true
  end
end
