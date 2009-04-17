require 'ronin/extensions/kernel'

require 'spec_helper'

describe Kernel do
  it "should provide Kernel#try" do
    Kernel.respond_to?('try').should == true
  end

  describe "try" do
    it "should return the result of the block if nothing is raised" do
      try { 2 + 2 }.should == 4
    end

    it "should return nil if an exception is raised" do
      try { 2 + 'a' }.should be_nil
    end
  end
end
