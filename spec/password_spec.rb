require 'spec_helper'
require 'ronin/password'

describe Password do
  let(:password) { 'secret' }
  subject { Password.new(:clear_text => password) }

  it "should require a clear-text password" do
    pass = Password.new

    pass.should_not be_valid
  end

  describe "#digest" do
    let(:salt) { 'foo' }

    it "should calculate the digest of the password" do
      digest = subject.digest(:sha1)
      
      digest.should == Digest::SHA1.hexdigest(password)
    end

    it "should calculate the digest of the password and prepended salt" do
      digest = subject.digest(:sha1, :prepend_salt => salt)
      
      digest.should == Digest::SHA1.hexdigest(salt + password)
    end

    it "should calculate the digest of the password and appended salt" do
      digest = subject.digest(:sha1, :append_salt => salt)
      
      digest.should == Digest::SHA1.hexdigest(password + salt)
    end
  end

  it "should be convertable to a String" do
    subject.to_s.should == password
  end
end
