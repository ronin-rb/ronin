require 'model/spec_helper'
require 'model/models/licensed_model'

require 'ronin/model/has_license'

describe Model::HasLicense do
  subject { LicensedModel }

  before(:all) do
    subject.auto_migrate!

    subject.create(
      :content => 'stuff here',
      :license => License.gpl2
    )
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

  it "should not require a license" do
    resource = subject.new(:content => 'bla')

    resource.should be_valid
  end

  describe "licensed_under" do
    let(:license) { License.gpl2 }

    it "should accept License resources" do
      resource = subject.licensed_under(license).first

      resource.license.should == license
    end

    it "should accept the names of predefined Licenses" do
      resource = subject.licensed_under(:gpl2).first

      resource.license.should == license
    end

    it "should accept the names of licenses" do
      resource = subject.licensed_under('GPL-2').first

      resource.license.should == license
    end
  end
end
