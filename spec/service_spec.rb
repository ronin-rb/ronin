require 'spec_helper'
require 'ronin/service'

describe Service do
  before(:all) { @service = Service.create(:name => 'Apache') }

  it "should require a name" do
    service = Service.new

    service.should_not be_valid
  end

  it "should require a unique name" do
    service = Service.new(:name => 'Apache')

    service.should_not be_valid
  end
end
