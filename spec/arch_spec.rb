require 'spec_helper'
require 'ronin/arch'

describe Arch do
  it "should require a name, endian and address_length attributes" do
    arch = Arch.new
    arch.should_not be_valid
    
    arch.name = 'future'
    arch.should_not be_valid
   
    arch.endian = 'little'
    arch.should_not be_valid

    arch.address_length = 4
    arch.should be_valid
  end

  it "should require a unique name" do
    first_arch = Arch.create(:name => 'cats',
                              :endian => 'little',
                              :address_length => 4)
    first_arch.should be_valid

    second_arch = Arch.new(:name => 'cats',
                            :endian => 'big',
                            :address_length => 4)
    second_arch.should_not be_valid
  end

  it "should require either 'little' or 'big' for the endian attribute" do
    arch = Arch.new(:name => 'test',
                     :endian => 'lol',
                     :address_length => 4)
    arch.should_not be_valid

    arch.endian = 'little'
    arch.should be_valid

    arch.endian = 'big'
    arch.should be_valid
  end

  it "should require a numeric valid for the address_length attribute" do
    arch = Arch.new(:name => 'test2',
                     :endian => 'big',
                     :address_length => 'x')
    arch.should_not be_valid

    arch.address_length = '4'
    arch.should be_valid

    arch.address_length = 4
    arch.should be_valid
  end

  it "should provide built-in archs" do
    Arch.i386.should_not be_nil
  end

  it "should allow custom names for built-in archs" do
    Arch.x86_64.name.should == 'x86-64'
  end
end
