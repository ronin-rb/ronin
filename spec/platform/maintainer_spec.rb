require 'spec_helper'
require 'platform/spec_helper'

require 'ronin/platform/maintainer'

describe Platform::Maintainer do
  describe "to_s" do
    it "should return the name when their is no email" do
      named = Platform::Maintainer.new(:name => 'anonymous')

      named.to_s.should == 'anonymous'
    end

    it "should return the name and email when both are present" do
      name_with_email = Platform::Maintainer.new(
        :name => 'anonymous',
        :email => 'anonymous@example.com'
      )

      name_with_email.to_s.should == 'anonymous <anonymous@example.com>'
    end
  end
end
