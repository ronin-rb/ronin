require 'ronin/network/helpers/helper'

require 'spec_helper'
require 'network/helpers/classes/test_helper'
require 'network/helpers/classes/uses_test_helper'

describe Network::Helpers::Helper do
  describe "require_variable" do
    before(:each) do
      @obj = UsesTestHelper.new
      @obj.host = 'www.example.com'
    end

    it "should raise a RuntimeError exception if a variable is nil" do
      lambda {
        @obj.host = nil
        @obj.connect
      }.should raise_error(RuntimeError)
    end

    it "should do nothing if the variable is not nil" do
      @obj.connect.should == @obj.host
    end
  end
end
