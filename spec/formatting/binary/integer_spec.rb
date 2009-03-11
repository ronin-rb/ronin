require 'ronin/formatting/binary'

require 'spec_helper'

describe Integer do
  it "should provide Integer#bytes" do
    Integer.instance_method('bytes').should_not be_nil
  end

  it "should provide Integer#pack" do
    Integer.instance_method('pack').should_not be_nil
  end

  it "should provide Integer#hex_escape" do
    Integer.instance_method('hex_escape').should_not be_nil
  end

  describe "bytes" do
    before(:all) do
      @integer = 0x1337

      @little_endian_char = [0x37]
      @little_endian_short = [0x37, 0x13]
      @little_endian_long = [0x37, 0x13, 0x0, 0x0]
      @little_endian_quad = [0x37, 0x13, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0]

      @big_endian_char = [0x37]
      @big_endian_short = [0x13, 0x37]
      @big_endian_long = [0, 0, 0x13, 0x37]
      @big_endian_quad = [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x13, 0x37]
    end

    it "should return the bytes in little endian ordering" do
      @integer.bytes(4).should == @little_endian_long
    end

    it "should return the bytes for a char in little endian ordering" do
      @integer.bytes(1).should == @little_endian_char
    end

    it "should return the bytes for a short in little endian ordering" do
      @integer.bytes(2).should == @little_endian_short
    end

    it "should return the bytes for a long in little endian ordering" do
      @integer.bytes(4).should == @little_endian_long
    end

    it "should return the bytes for a quad in little endian ordering" do
      @integer.bytes(8).should == @little_endian_quad
    end

    it "should return the bytes in big endian ordering" do
      @integer.bytes(4, :big).should == @big_endian_long
    end

    it "should return the bytes for a char in big endian ordering" do
      @integer.bytes(1, :big).should == @big_endian_char
    end

    it "should return the bytes for a short in big endian ordering" do
      @integer.bytes(2, :big).should == @big_endian_short
    end

    it "should return the bytes for a long in big endian ordering" do
      @integer.bytes(4, :big).should == @big_endian_long
    end

    it "should return the bytes for a quad in big endian ordering" do
      @integer.bytes(8, :big).should == @big_endian_quad
    end
  end

  describe "pack" do
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

    it "should pack itself for a little-endian architecture" do
      @integer.pack(Arch.i386).should == @i386_packed_int
    end

    it "should pack itself as a short for a little-endian architecture" do
      @integer.pack(Arch.i386,2).should == @i386_packed_short
    end

    it "Integer#pack should pack itself as a long for a little-endian architecture" do
      @integer.pack(Arch.i386,4).should == @i386_packed_long
    end

    it "should pack itself as a quad for a little-endian architecture" do
      @integer.pack(Arch.i386,8).should == @i386_packed_quad
    end

    it "should pack itself for a big-endian architecture" do
      @integer.pack(Arch.ppc).should == @ppc_packed_int
    end

    it "should pack itself as a short for a big-endian architecture" do
      @integer.pack(Arch.ppc,2).should == @ppc_packed_short
    end

    it "should pack itself as a long for a big-endian architecture" do
      @integer.pack(Arch.ppc,4).should == @ppc_packed_long
    end

    it "should pack itself as a quad for a big-endian architecture" do
      @integer.pack(Arch.ppc,8).should == @ppc_packed_quad
    end
  end

  describe "hex_escape" do
    it "should hex escape an Integer" do
      42.hex_escape.should == "\\x2a"
    end
  end
end
