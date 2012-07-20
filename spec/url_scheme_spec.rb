require 'spec_helper'

require 'ronin/url_scheme'

describe URLScheme do
  before(:all) { described_class.create(:name => 'http') }

  describe "validations" do
    it "should require a name" do
      subject.should_not be_valid
    end

    describe "name" do
      subject { described_class.new(:name => 'http') }

      it "should require a unique name" do
        subject.should_not be_valid
      end
    end
  end
end
