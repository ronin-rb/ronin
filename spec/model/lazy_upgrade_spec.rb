require 'spec_helper'
require 'ronin/model/lazy_upgrade'

require 'model/models/lazy_model'

describe Ronin::Model::LazyUpgrade do
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
