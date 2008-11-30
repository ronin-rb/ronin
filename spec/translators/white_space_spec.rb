require 'ronin/translators/white_space'

require 'spec_helper'

describe Ronin do
  describe Translators::WhiteSpace do
    before(:all) do
      @text = (0..255).to_a.map { |b| b.chr }.join
      @translator = Translators::WhiteSpace.new
    end

    it "should encode arbitrary data into white-space data" do
      @translator.encode(@text).should =~ /^\s+$/
    end

    it "should decode white-space encoded data" do
      @translator.decode(@translator.encode(@text)).should == @text
    end
  end
end
