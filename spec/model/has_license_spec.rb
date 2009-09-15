require 'ronin/model/has_license'

require 'spec_helper'
require 'model/classes/licensed_model'

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
    model = LicensedModel.new(:content => 'bla')
    model.license = License.gpl2
    model.save

    model.license.should == License.gpl2
  end

  it "should provide helper methods for querying licensed models" do
    model = LicensedModel.new(:content => 'stuff here')
    model.license = License.gpl2
    model.save
    model.reload

    LicensedModel.all(
      :content.like => '%stuff%'
    ).licensed_under(:gpl2).first.should == model
  end
end
