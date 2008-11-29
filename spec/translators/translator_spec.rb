require 'ronin/translators/translator'

require 'spec_helper'

describe Ronin do
  describe Translators::Translator do
    it "should create a new Translator object with options" do
      Translators::Translator.new(:test => 1).should_not be_nil
    end

    it "should create a new Translator object with options and a block" do
      Translators::Translator.new(:test => 2) do |translator|
        translator.should_not be_nil
      end
    end

    it "should encode data with given options" do
      data = 'test'

      Translators::Translator.encode(data,:test => 3).should == data
    end

    it "should encode data with given options and a block" do
      data = 'test'

      Translators::Translator.encode(data,:test => 4) do |encoded|
        encoded.should == data
      end
    end

    it "should provide a default encode method" do
      data = 'test'
      translator = Translators::Translator.new

      translator.encode(data).should == data
    end

    it "should provide a default encode method which receives a block" do
      data = 'test'
      translator = Translators::Translator.new

      translator.encode(data) do |encoded|
        encoded.should == data
      end
    end

    it "should provide a default decode method" do
      data = 'test'
      translator = Translators::Translator.new

      translator.decode(data).should == data
    end

    it "should provide a default decode method which receives a block" do
      data = 'test'
      translator = Translators::Translator.new

      translator.decode(data) do |decoded|
        decoded.should == data
      end
    end
  end
end
