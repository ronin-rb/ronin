require 'spec_helper'
require 'ronin/email_address'

describe EmailAddress do
  let(:user) { 'joe' }
  let(:host) { 'example.com' }
  let(:email) { "#{user}@#{host}" }

  subject {
    EmailAddress.new(
      :user_name => {:name => user},
      :host_name => {:address => host}
    )
  }

  describe "parse" do
    it "should parse email addresses" do
      email_address = EmailAddress.parse(email)

      email_address.user_name.name.should == user
      email_address.host_name.address.should == host
    end

    it "should strip whitespace from emails" do
      email_address = EmailAddress.parse("  #{email} ")

      email_address.user_name.name.should == user
      email_address.host_name.address.should == host
    end
  end

  it "should provide the user-name" do
    subject.user.should == user
  end

  it "should provide the host-name" do
    subject.host.should == host
  end

  it "should convert to a String" do
    subject.to_s.should == email
  end

  it "should implicitly splat the user-name and host-name" do
    user_name, host_name = subject

    user_name.should == user
    host_name.should == host
  end
end
