require 'ronin/code/reference'

require 'spec_helper'

describe Code::Reference do
  before(:all) do
    class Thing

      def exposed
        1
      end

      protected

      def not_exposed
        2
      end

    end

    @object = Thing.new
    @ref = Code::Reference.new(@object)
  end

  it "should provide direct access to the referenced object" do
    @ref.value.should == @object
  end

  it "should relay method calls to the referenced object" do
    @ref.exposed.should == 1
  end

  it "should raise a NoMethodError when trying to call a protected or private method" do
    lambda { @ref.not_exposed }.should raise_error(NoMethodError)
  end
end
