require 'ronin/model/lazy_setup'

require 'spec_helper'
require 'model/classes/lazy_model'

describe Ronin::Model::LazySetup do
  describe "pre auto_upgrade" do
    it "should not be auto_upgraded after being loaded" do
      LazyModel.should_not be_auto_upgraded
    end
  end

  describe "post auto_upgrade" do
    it "should be auto_upgraded after lazy_upgrade!" do
      LazyModel.lazy_upgrade!

      LazyModel.should be_auto_upgraded
    end
  end
end
