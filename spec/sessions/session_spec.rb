require 'ronin/sessions/session'

require 'spec_helper'
require 'sessions/helpers/test_session'
require 'sessions/helpers/test_session_class'
require 'sessions/helpers/test_session_object'

describe Sessions::Session do
  before(:all) do
    @session_obj = TestSessionObject.new
    @session_obj.extend TestSession
  end

  it "should add self.setup_session to a Module" do
    lambda {
      TestSession.method(:setup_session)
    }.should_not raise_error(NameError)
  end

  describe "setup_session" do
    it "should add self.included and self.extended methods once setup_session is called" do
      lambda {
        TestSession.method(:included)
      }.should_not raise_error(NameError)

      lambda {
        TestSession.method(:extended)
      }.should_not raise_error(NameError)
    end

    it "should run the setup_session proc once included" do
      TestSessionClass.var.should == :stuff
    end

    it "should run the setup_session proc once extended" do
      @session_obj.var.should == :stuff
    end
  end

  it "should include Parameters once included" do
    TestSessionClass.include?(Parameters).should == true
  end

  it "should extend Parameters once extended" do
    @session_obj.kind_of?(Parameters).should == true
  end
end
