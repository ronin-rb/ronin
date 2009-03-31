require 'ronin/code/reference'

require 'spec_helper'
require 'code/helpers/thing'

describe Code::Reference do
  before(:all) do
    @object = Thing.new
    @ref = Code::Reference.new(@object)
  end

  it "should provide direct access to the referenced object" do
    @ref.value.should == @object
  end

  it "should be a kind of Reference" do
    @ref.kind_of?(Code::Reference).should == true
    @ref.is_a?(Code::Reference).should == true
    @ref.instance_of?(Code::Reference).should == true
  end

  it "should have the class of the referenced object" do
    @ref.class.should == Thing
  end

  it "should be a kind of the referenced object type" do
    @ref.kind_of?(Thing).should == true
    @ref.is_a?(Thing).should == true
    @ref.instance_of?(Thing).should == true
  end

  it "should be equal to itself" do
    @ref.eql?(@ref).should == true
    @ref.should == @ref
    @ref.should === @ref
  end

  it "should be equal to the referenced object" do
    @ref.eql?(@object).should == true
    @ref.should == @object
    @ref.should === @object
  end

  it "should respond to Reference methods" do
    @ref.respond_to?(:value).should == true
  end

  it "should respond to the methods of the referenced object" do
    @ref.respond_to?(:exposed).should == true
  end

  it "should relay method calls to the referenced object" do
    @ref.exposed.should == 1
  end

  it "should raise a NoMethodError when trying to call a protected or private method" do
    lambda { @ref.not_exposed }.should raise_error(NoMethodError)
  end
end
