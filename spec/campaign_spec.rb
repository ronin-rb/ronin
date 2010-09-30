require 'spec_helper'
require 'ronin/campaign'

describe Campaign do
  describe "dir_name" do
    it "should raise a ValidationError if no name was assigned" do
      campaign = Campaign.new
      
      lambda {
        campaign.dir_name
      }.should raise_error(DataMapper::ValidationError)
    end

    it "should downcase the campaign name" do
      campaign = Campaign.new(:name => 'Stuff')

      campaign.dir_name.should == 'stuff'
    end

    it "should replace spaces with underscores" do
      campaign = Campaign.new(:name => 'More   Stuff')

      campaign.dir_name.should == 'more_stuff'
    end

    it "should file-escape the downcased campaign name" do
      campaign = Campaign.new(:name => 'Stuff / ..')

      campaign.dir_name.should == 'stuff_\/_..'
    end
  end
end
