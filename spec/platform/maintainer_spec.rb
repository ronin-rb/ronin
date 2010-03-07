require 'ronin/platform/maintainer'

require 'spec_helper'

describe Platform::Maintainer do
  before(:all) do
    @named = Platform::Maintainer.new(:name => 'anonymous')
    @name_with_email = Platform::Maintainer.new(
      :name => 'anonymous',
      :email => 'anonymous@example.com'
    )
  end

  describe "to_s" do
    it "should return the name when their is no email" do
      @named.to_s.should == 'anonymous'
    end

    it "should return the name and email when both are present" do
      @name_with_email.to_s.should == 'anonymous <anonymous@example.com>'
    end
  end
end
