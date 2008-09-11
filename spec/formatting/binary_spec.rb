require 'ronin/formatting/binary'

require 'spec_helper'

describe Integer do
  before(:all) do
    @integer = 0x1337

    @i386_packed_int = "7\023\000\000"
    @i386_packed_short = "7\023"
    @i386_packed_long = "7\023\000\000"
    @i386_packed_quad = "7\023\000\000\000\000\000\000"

    @ppc_packed_int = "\000\000\0237"
    @ppc_packed_short = "\0237"
    @ppc_packed_long = "\000\000\0237"
    @ppc_packed_quad = "\000\000\000\000\000\000\0237"
  end

  it "should provide Integer#pack" do
    @integer.respond_to?('pack').should == true
  end

  it "Integer#pack should pack itself for a little-endian architecture" do
    @integer.pack(Arch.i386).should == @i386_packed_int
  end

  it "Integer#pack should pack itself as a short for a little-endian architecture" do
    @integer.pack(Arch.i386,2).should == @i386_packed_short
  end

  it "Integer#pack should pack itself as a long for a little-endian architecture" do
    @integer.pack(Arch.i386,4).should == @i386_packed_long
  end

  it "Integer#pack should pack itself as a quad for a little-endian architecture" do
    @integer.pack(Arch.i386,8).should == @i386_packed_quad
  end

  it "Integer#pack should pack itself for a big-endian architecture" do
    @integer.pack(Arch.ppc).should == @ppc_packed_int
  end

  it "Integer#pack should pack itself as a short for a big-endian architecture" do
    @integer.pack(Arch.ppc,2).should == @ppc_packed_short
  end

  it "Integer#pack should pack itself as a long for a big-endian architecture" do
    @integer.pack(Arch.ppc,4).should == @ppc_packed_long
  end

  it "Integer#pack should pack itself as a quad for a big-endian architecture" do
    @integer.pack(Arch.ppc,8).should == @ppc_packed_quad
  end
end

describe "String" do
  before(:all) do
    @packed_integer = ""
  end

  it "should provide String#depack" do
    @packed_integer.respond_to?('depack').should == true
  end
end
