require 'ronin/formatting/binary'

require 'spec_helper'
require 'formatting/binary/helpers/hexdumps'

describe String do
  it "should provide String#depack" do
    String.method_defined?(:depack).should == true
  end

  it "should provide String#zlib_inflate" do
    String.method_defined?(:zlib_inflate).should == true
  end

  it "should provide String#zlib_deflate" do
    String.method_defined?(:zlib_deflate).should == true
  end

  it "should provide String#hex_unescape" do
    String.method_defined?(:hex_unescape).should == true
  end

  it "should provide String#xor" do
    String.method_defined?(:xor).should == true
  end

  it "should provide String#unhexdump" do
    String.method_defined?(:unhexdump).should == true
  end

  describe "depack" do
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

    it "should depack itself for a little-endian architecture" do
      @i386_packed_int.depack(Arch.i386).should == @integer
    end

    it "should depack itself as a short for a little-endian architecture" do
      @i386_packed_short.depack(Arch.i386,2).should == @integer
    end

    it "should depack itself as a long for a little-endian architecture" do
      @i386_packed_long.depack(Arch.i386,4).should == @integer
    end

    it "should depack itself as a quad for a little-endian architecture" do
      @i386_packed_quad.depack(Arch.i386,8).should == @integer
    end

    it "should depack itself for a big-endian architecture" do
      @ppc_packed_int.depack(Arch.ppc).should == @integer
    end

    it "should depack itself as a short for a big-endian architecture" do
      @ppc_packed_short.depack(Arch.ppc,2).should == @integer
    end

    it "should depack itself as a long for a big-endian architecture" do
      @ppc_packed_long.depack(Arch.ppc,4).should == @integer
    end

    it "should depack itself as a quad for a big-endian architecture" do
      @ppc_packed_quad.depack(Arch.ppc,8).should == @integer
    end
  end

  describe "zlib_inflate" do
    before(:all) do
      @zlib_chunk = "x\xda3H\xb3H3MM6\xd354II\xd651K5\xd7M43N\xd4M\xb3\xb0L2O14423Mb\0\0\xc02\t\xae"
    end

    it "should inflate a zlib deflated String" do
      @zlib_chunk.zlib_inflate.should == "0f8f5ec6-14dc-46e7-a63a-f89b7d11265b\0"
    end
  end

  describe "zlib_deflate" do
    before(:all) do
      @string = "hello"
    end

    it "should zlib deflate a String" do
      @string.zlib_deflate.should == "x\x9c\xcbH\xcd\xc9\xc9\a\0\x06,\x02\x15"
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
      @string.include?(@key.chr).should_not == true
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
        hexdump = load_hexdump('hexdump_octal_bytes')

        hexdump.unhexdump(:format => :hexdump, :encoding => :octal_bytes).should == @ascii
      end

      it "should unhexdump hex-byte hexdump output" do
        hexdump = load_hexdump('hexdump_hex_bytes')

        hexdump.unhexdump(:format => :hexdump, :encoding => :hex_bytes).should == @ascii
      end

      it "should unhexdump decimal-short hexdump output" do
        hexdump = load_hexdump('hexdump_decimal_shorts')

        hexdump.unhexdump(:format => :hexdump, :encoding => :decimal_shorts).should == @ascii
      end

      it "should unhexdump octal-short hexdump output" do
        hexdump = load_hexdump('hexdump_octal_shorts')

        hexdump.unhexdump(:format => :hexdump, :encoding => :octal_shorts).should == @ascii
      end

      it "should unhexdump hex-short hexdump output" do
        hexdump = load_hexdump('hexdump_hex_shorts')

        hexdump.unhexdump(:format => :hexdump, :encoding => :hex_shorts).should == @ascii
      end

      it "should unhexdump repeated hexdump output" do
        hexdump = load_hexdump('hexdump_repeated')

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
