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

  it "should convert to a String" do
    subject.to_s.should == email
  end
end
