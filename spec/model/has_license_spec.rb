require 'ronin/model/has_license'

require 'spec_helper'
require 'model/models/licensed_model'

describe Model::HasLicense do
  before(:all) do
    LicensedModel.auto_migrate!
  end

  it "should define a license relationship" do
    relationship = LicensedModel.relationships['license']

    relationship.should_not be_nil
    relationship.parent_model.should == License
  end

  it "should define relationships with License" do
    relationship = License.relationships['licensed_models']
    
    relationship.should_not be_nil
    relationship.child_model.should == LicensedModel
  end

  it "should have a license" do
    model = LicensedModel.create!(
      :content => 'bla',
      :license => License.gpl2
    )

    model.license.should == License.gpl2
  end

  it "should provide helper methods for querying licensed models" do
    model = LicensedModel.create!(
      :content => 'stuff here',
      :license => License.gpl2
    )

    LicensedModel.licensed_under(:gpl2).first == model
  end
end
