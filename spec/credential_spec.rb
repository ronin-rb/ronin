require 'spec_helper'

require 'ronin/credential'

describe Credential do
  let(:name)     { 'alice'  }
  let(:password) { 'secret' }

  subject do
    described_class.new(
      :user_name => {:name => name},
      :password  => {:clear_text => password}
    )
  end

  it "should provide the user-name" do
    subject.user.should == name
  end

  it "should provide the clear-text password" do
    subject.clear_text.should == password
  end

  describe "#to_s" do
    it "should include the user name and password" do
      subject.to_s.should == "#{name}:#{password}"
    end
  end
end
