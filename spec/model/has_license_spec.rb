require 'ronin/model/has_license'

require 'spec_helper'
require 'model/classes/licensed_model'

describe Model::HasLicense do
  before(:all) do
    LicensedModel.auto_migrate!
  end

  it "should have a license" do
    model = LicensedModel.new(:content => 'bla')
    model.license = License.gpl_2
    model.save!

    model.license.should == License.gpl_2
  end

  it "should provide helper methods for querying licensed models" do
    model = LicensedModel.new(:content => 'stuff here')
    model.license = License.gpl_2
    model.save!
    model.reload

    LicensedModel.all(
      :content.like => '%stuff%'
    ).licensed_under(:gpl_2).first.should == model
  end
end
