require 'spec_helper'
require 'ronin/credential'

describe Credential do
  let(:name) { 'alice' }
  let(:secret) { 'secret' }

  subject do
    Credential.new(
      :user_name => {:name => name},
      :password => {:clear_text => secret}
    )
  end

  it "should provide the user-name" do
    subject.user.should == name
  end

  it "should provide the clear-text password" do
    subject.clear_text.should == secret
  end

  it "should be convertable to a String" do
    subject.to_s.should == "#{name}:#{secret}"
  end
end
