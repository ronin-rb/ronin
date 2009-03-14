require 'ronin/formatting/binary'

require 'spec_helper'

describe Integer do
  it "should provide Integer#pack" do
    Integer.instance_method('pack').should_not be_nil
  end

  it "should provide Integer#hex_escape" do
    Integer.instance_method('hex_escape').should_not be_nil
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

    it "should pack itself as a long for a little-endian architecture" do
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
