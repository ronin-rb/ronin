require 'ronin/formatting/digest'

require 'spec_helper'

describe String do
  before(:all) do
    @string = "test"
  end

  it "should provide String#md5" do
    String.method_defined?(:md5).should == true
  end

  it "should provide String#sha1" do
    String.method_defined?(:sha1).should == true
  end

  it "should provide String#sha2" do
    String.method_defined?(:sha2).should == true
  end

  it "should provide String#sha256" do
    String.method_defined?(:sha256).should == true
  end

  it "should provide String#sha512" do
    String.method_defined?(:sha512).should == true
  end

  describe "md5" do
    before(:all) do
      @digest_plain_text = "test"
      @digest_md5 = "098f6bcd4621d373cade4e832627b4f6"
    end

    it "should return the MD5 digest of itself" do
      @digest_plain_text.md5.should == @digest_md5
    end
  end

  describe "sha1" do
    before(:all) do
      @digest_plain_text = "test"
      @digest_sha1 = "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
    end

    it "should return the SHA1 digest of itself" do
      @digest_plain_text.sha1.should == @digest_sha1
    end
  end

  describe "sha2" do
    before(:all) do
      @digest_plain_text = "test"
      @digest_sha2 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
    end

    it "should return the SHA2 digest of itself" do
      @digest_plain_text.sha2.should == @digest_sha2
    end
  end

  describe "sha256" do
    before(:all) do
      @digest_plain_text = "test"
      @digest_sha256 = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
    end

    it "should return the SHA256 digest of itself" do
      @digest_plain_text.sha256.should == @digest_sha256
    end
  end

  describe "sha512" do
    before(:all) do
      @digest_plain_text = "test"
      @digest_sha512 = "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"
    end

    it "should return the SHA512 digest of itself" do
      @digest_plain_text.sha512.should == @digest_sha512
    end
  end
end
