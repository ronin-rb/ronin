require 'ronin/code/reference'

require 'spec_helper'
require 'code/classes/thing'

describe Code::Reference do
  before(:all) do
    @object = Thing.new
    @ref = Code::Reference.new(@object)
  end

  it "should provide direct access to the referenced object" do
    @ref.value.should == @object
  end

  it "should be a kind of Reference" do
    @ref.should be_kind_of(Code::Reference)
    @ref.should be_is_a(Code::Reference)
    @ref.should be_instance_of(Code::Reference)
  end

  it "should have the class of the referenced object" do
    @ref.class.should == Thing
  end

  it "should be a kind of the referenced object type" do
    @ref.should be_kind_of(Thing)
    @ref.should be_is_a(Thing)
    @ref.should be_instance_of(Thing)
  end

  it "should be equal to itself" do
    @ref.should eql(@ref)
    @ref.should == @ref
    @ref.should === @ref
  end

  it "should be equal to the referenced object" do
    @ref.should be_eql(@object)
    @ref.should == @object
    @ref.should === @object
  end

  it "should respond to Reference methods" do
    @ref.should respond_to(:value)
  end

  it "should respond to the methods of the referenced object" do
    @ref.should respond_to(:exposed)
  end

  it "should relay method calls to the referenced object" do
    @ref.exposed.should == 1
  end

  it "should raise a NoMethodError when trying to call a protected or private method" do
    lambda { @ref.not_exposed }.should raise_error(NoMethodError)
  end

  it "should inspect the referenced object when inspect is called" do
    @ref.inspect.should == '#<Thing: stuff>'
  end
end
