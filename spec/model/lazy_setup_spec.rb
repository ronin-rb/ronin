require 'ronin/model/lazy_setup'

require 'spec_helper'
require 'model/classes/lazy_model'

describe Ronin::Model::LazySetup do
  it "should not be auto_upgrade after being loaded" do
    LazyModel.should_not be_auto_upgraded
  end

  it "should auto_upgrade when first accessed" do
    LazyModel.all

    LazyModel.should be_auto_upgraded
  end
end
