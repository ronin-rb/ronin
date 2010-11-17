require 'model/spec_helper'
require 'model/models/licensed_model'

require 'ronin/model/has_license'

describe Model::HasLicense do
  subject { LicensedModel }

  before(:all) do
    subject.auto_migrate!
  end

  it "should define a license relationship" do
    relationship = subject.relationships['license']

    relationship.should_not be_nil
    relationship.parent_model.should == License
  end

  it "should define relationships with License" do
    relationship = License.relationships['licensed_models']
    
    relationship.should_not be_nil
    relationship.child_model.should == subject
  end

  it "should have a license" do
    model = subject.create!(
      :content => 'bla',
      :license => License.gpl2
    )

    model.license.should == License.gpl2
  end

  it "should provide helper methods for querying licensed models" do
    model = subject.create!(
      :content => 'stuff here',
      :license => License.gpl2
    )

    subject.licensed_under(:gpl2).first == model
  end
end
