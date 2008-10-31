require 'ronin/encoders/encoder'

require 'spec_helper'

describe Encoder do
  it "should create a new Encoder object with options" do
    Encoder.new(:test => 1).should_not be_nil
  end

  it "should create a new Encoder object with options and a block" do
    Encoder.new(:test => 2) do |encoder|
      encoder.should_not be_nil
    end
  end

  it "should encode data with given options" do
    data = 'test'

    Encoder.encode(data,:test => 3).should == data
  end

  it "should encode data with given options and a block" do
    data = 'test'

    Encoder.encode(data,:test => 4) do |encoded|
      encoded.should == data
    end
  end

  it "should provide a default encode method" do
    data = 'test'
    encoder = Encoder.new

    encoder.encode(data).should == data
  end

  it "should provide a default encode method which receives a block" do
    data = 'test'
    encoder = Encoder.new

    encoder.encode(data) do |encoded|
      encoded.should == data
    end
  end
end
