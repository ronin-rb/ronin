require 'ronin/formatting/binary'

require 'spec_helper'
require 'formatting/binary/helpers/hexdumps'

describe String do
  it "should provide String#depack" do
    String.instance_method('depack').should_not be_nil
  end

  it "should provide String#hex_escape" do
    String.instance_method('hex_escape').should_not be_nil
  end

  it "should provide String#hex_unescape" do
    String.instance_method('hex_unescape').should_not be_nil
  end

  it "should provide String#xor" do
    String.instance_method('xor').should_not be_nil
  end

  it "should provide String#unhexdump" do
    String.instance_method('unhexdump').should_not be_nil
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
      @i386_packed_int.depack(Arch.i386).should == @integer
    end

    it "should pack itself as a short for a little-endian architecture" do
      @i386_packed_short.depack(Arch.i386,2).should == @integer
    end

    it "Integer#pack should pack itself as a long for a little-endian architecture" do
      @i386_packed_long.depack(Arch.i386,4).should == @integer
    end

    it "should pack itself as a quad for a little-endian architecture" do
      @i386_packed_quad.depack(Arch.i386,8).should == @integer
    end

    it "should pack itself for a big-endian architecture" do
      @ppc_packed_int.depack(Arch.ppc).should == @integer
    end

    it "should pack itself as a short for a big-endian architecture" do
      @ppc_packed_short.depack(Arch.ppc,2).should == @integer
    end

    it "should pack itself as a long for a big-endian architecture" do
      @ppc_packed_long.depack(Arch.ppc,4).should == @integer
    end

    it "should pack itself as a quad for a big-endian architecture" do
      @ppc_packed_quad.depack(Arch.ppc,8).should == @integer
    end
  end

  describe "hex_escape" do
    before(:all) do
      @binary_string = "hello\x4e"
    end

    it "should hex escape a String" do
      @binary_string.hex_escape.should == "\\x68\\x65\\x6c\\x6c\\x6f\\x4e"
    end
  end

  describe "hex_unescape" do
    it "should unescape a normal String" do
      "hello".hex_unescape.should == "hello"
    end

    it "should unescape a hex String" do
      "\\x68\\x65\\x6c\\x6c\\x6f\\x4e".hex_unescape.should == "hello\x4e"
    end

    it "should unescape an octal String" do
      "hello\012".hex_unescape.should == "hello\n"
    end

    it "should unescape control characters" do
      "hello\\n".hex_unescape.should == "hello\n"
    end
  end

  describe "xor" do
    before(:all) do
      @string = 'hello'
      @key = 0x50
    end

    it "should not contain the key used in the xor" do
      @string.include?(@key).should_not == true
    end

    it "should not equal the original string" do
      @string.xor(@key).should_not == @string
    end

    it "should be able to be decoded with another xor" do
      @string.xor(@key).xor(@key).should == @string
    end
  end

  describe "unhexdump" do
    describe "GNU hexdump" do
      before(:all) do
        @ascii = load_binary_data('ascii')
        @repeated = load_binary_data('repeated')
      end

      it "should unhexdump octal-byte hexdump output" do
        hexdump = load_hexdump('gnu_hexdump_octal_bytes')

        hexdump.unhexdump(:format => :hexdump, :encoding => :octal_bytes).should == @ascii
      end

      it "should unhexdump hex-byte hexdump output" do
        hexdump = load_hexdump('gnu_hexdump_hex_bytes')

        hexdump.unhexdump(:format => :hexdump, :encoding => :hex_bytes).should == @ascii
      end

      it "should unhexdump decimal-short hexdump output" do
        hexdump = load_hexdump('gnu_hexdump_decimal_shorts')

        hexdump.unhexdump(:format => :hexdump, :encoding => :decimal_shorts).should == @ascii
      end

      it "should unhexdump octal-short hexdump output" do
        hexdump = load_hexdump('gnu_hexdump_octal_shorts')

        hexdump.unhexdump(:format => :hexdump, :encoding => :octal_shorts).should == @ascii
      end

      it "should unhexdump hex-short hexdump output" do
        hexdump = load_hexdump('gnu_hexdump_hex_shorts')

        hexdump.unhexdump(:format => :hexdump, :encoding => :hex_shorts).should == @ascii
      end

      it "should unhexdump repeated hexdump output" do
        hexdump = load_hexdump('gnu_hexdump_repeated')

        hexdump.unhexdump(:format => :hexdump, :encoding => :hex_bytes).should == @repeated
      end
    end

    describe "od" do
      before(:all) do
        @ascii = load_binary_data('ascii')
        @repeated = load_binary_data('repeated')
      end

      it "should unhexdump octal-byte hexdump output" do
        hexdump = load_hexdump('od_octal_bytes')

        hexdump.unhexdump(:format => :od, :encoding => :octal_bytes).should == @ascii
      end

      it "should unhexdump octal-shorts hexdump output" do
        hexdump = load_hexdump('od_octal_shorts')

        hexdump.unhexdump(:format => :od, :encoding => :octal_shorts).should == @ascii
      end

      it "should unhexdump octal-ints hexdump output" do
        hexdump = load_hexdump('od_octal_ints')

        hexdump.unhexdump(:format => :od, :encoding => :octal_ints).should == @ascii
      end

      it "should unhexdump octal-quads hexdump output" do
        hexdump = load_hexdump('od_octal_quads')

        hexdump.unhexdump(:format => :od, :encoding => :octal_quads).should == @ascii
      end

      it "should unhexdump decimal-byte hexdump output" do
        hexdump = load_hexdump('od_decimal_bytes')

        hexdump.unhexdump(:format => :od, :encoding => :decimal_bytes).should == @ascii
      end

      it "should unhexdump decimal-shorts hexdump output" do
        hexdump = load_hexdump('od_decimal_shorts')

        hexdump.unhexdump(:format => :od, :encoding => :decimal_shorts).should == @ascii
      end

      it "should unhexdump decimal-ints hexdump output" do
        hexdump = load_hexdump('od_decimal_ints')

        hexdump.unhexdump(:format => :od, :encoding => :decimal_ints).should == @ascii
      end

      it "should unhexdump decimal-quads hexdump output" do
        hexdump = load_hexdump('od_decimal_quads')

        hexdump.unhexdump(:format => :od, :encoding => :decimal_quads).should == @ascii
      end

      it "should unhexdump hex-byte hexdump output" do
        hexdump = load_hexdump('od_hex_bytes')

        hexdump.unhexdump(:format => :od, :encoding => :hex_bytes).should == @ascii
      end

      it "should unhexdump hex-shorts hexdump output" do
        hexdump = load_hexdump('od_hex_shorts')

        hexdump.unhexdump(:format => :od, :encoding => :hex_shorts).should == @ascii
      end

      it "should unhexdump hex-ints hexdump output" do
        hexdump = load_hexdump('od_hex_ints')

        hexdump.unhexdump(:format => :od, :encoding => :hex_ints).should == @ascii
      end

      it "should unhexdump hex-quads hexdump output" do
        hexdump = load_hexdump('od_hex_quads')

        hexdump.unhexdump(:format => :od, :encoding => :hex_quads).should == @ascii
      end

      it "should unhexdump repeated hexdump output" do
        hexdump = load_hexdump('od_repeated')

        hexdump.unhexdump(:format => :od, :encoding => :octal_shorts).should == @repeated
      end
    end
  end
end
