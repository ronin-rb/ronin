require 'ronin/sessions/session'

require 'spec_helper'
require 'sessions/helpers/test_session'
require 'sessions/helpers/uses_test_session'

describe Sessions::Session do
  describe "require_variable" do
    before(:each) do
      @obj = UsesTestSession.new
      @obj.host = 'www.example.com'
    end

    it "should raise a VariableMissing exception if a variable is nil" do
      lambda {
        @obj.host = nil
        @obj.connect
      }.should raise_error(Sessions::VariableMissing)
    end

    it "should do nothing if the variable is not nil" do
      @obj.connect.should == @obj.host
    end
  end
end
