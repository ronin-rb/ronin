require 'spec_helper'

require 'ronin/service'

describe Service do
  let(:name) { 'Apache' }

  subject { described_class.new(:name => name) }
  before  { subject.save }

  describe "validations" do
    it "should require a name" do
      service = described_class.new

      service.should_not be_valid
    end

    it "should require a unique name" do
      service = described_class.new(:name => name)

      service.should_not be_valid
    end
  end
end
