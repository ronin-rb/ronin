require 'spec_helper'
require 'ronin/campaign'

describe Campaign do
  describe "filename" do
    it "should return nil if no name is set" do
      campaign = Campaign.new
      
      campaign.filename.should be_nil
    end

    it "should downcase the campaign name" do
      campaign = Campaign.new(:name => 'Stuff')

      campaign.filename.should == 'stuff'
    end

    it "should replace spaces with underscores" do
      campaign = Campaign.new(:name => 'More   Stuff')

      campaign.filename.should == 'more_stuff'
    end

    it "should replace non-alpha-numeric characters with undersocres" do
      campaign = Campaign.new(:name => 'Stuff / stuff1 & stuff2')

      campaign.filename.should == 'stuff_stuff1_stuff2'
    end
  end
end
