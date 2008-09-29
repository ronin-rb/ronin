require 'ronin/extensions/hash'

require 'spec_helper'

describe Hash do
  before(:all) do
    @hash = {:a => 1, :b => 2, :c => 3}
  end

  it "should be able to be exploded" do
    @exploded = @hash.explode(:x)
    @exploded.length.should == 3

    @exploded.each do |key,new_hash|
      new_hash[key].should == :x
    end
  end

  it "should explode only with specific keys" do
    @keys = [:a, :c]
    @exploded = @hash.explode(:x, :included => @keys)

    @exploded.each do |key,new_hash|
      @keys.include?(key).should == true
      new_hash[key].should == :x
    end
  end

  it "should not explode on specified keys" do
    @keys = [:b]
    @exploded = @hash.explode(:x, :excluded => @keys)

    @exploded.each do |key,new_hash|
      @keys.include?(key).should == false
      new_hash[key].should == :x
    end
  end
end
