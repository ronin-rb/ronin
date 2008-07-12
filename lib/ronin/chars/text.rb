#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/text/char_set'

module Ronin
  module Text
    # The numeric decimal character set
    NUMERIC = CharSet.new('0'..'9')

    # The octal character set
    OCTAL = CharSet.new('0'..'7')

    # The upper-case hexadecimal character set
    UPPERCASE_HEXADECIMAL = NUMERIC + ('A'..'F')

    # The lower-case hexadecimal character set
    LOWERCASE_HEXADECIMAL = NUMERIC + ('a'..'f')

    # The hexadecimal character set
    HEXADECIMAL = UPPERCASE_HEXADECIMAL + LOWERCASE_HEXADECIMAL

    # The upper-case alpha character set
    UPPERCASE_ALPHA = CharSet.new('A'..'Z')

    # The lower-case alpha character set
    LOWERCASE_ALPHA = CharSet.new('a'..'z')

    # The alpha character set
    ALPHA = UPPERCASE_ALPHA + LOWERCASE_ALPHA

    # The alpha-numeric character set
    ALPHA_NUMERIC = ALPHA + NUMERIC

    # The space character set
    SPACE = CharSet.new(' ', "\f", "\n", "\r", "\t", "\v")

    # The punctuation character set
    PUNCTUATION = CharSet.new(' ', '\'', '"', '`', ',', ';', ':', '~', '-',
                              '(', ')', '[', ']', '{', '}', '.', '?', '!')

    # The symbolic character set
    SYMBOLS = PUNCTUATION + ['@', '#', '$', '%', '^', '&', '*', '_', '+',
                             '=', '|', '\\', '<', '>', '/']

    # The control-char character set
    CONTROL = CharSet.new(0..0x1f, 0x7f)

    # The ASCII character set
    ASCII = CharSet.new(0..0x7f)

    # The full 8-bit character set
    ALL = CharSet.new(0..0xff)

    #
    # The numeric decimal character set.
    #
    def Text.numeric
      NUMERIC
    end

    #
    # The octal character set.
    #
    def Text.octal
      OCTAL
    end

    #
    # The upper-case hexadecimal character set.
    #
    def Text.uppercase_hexadecimal
      UPPERCASE_HEXADECIMAL
    end

    #
    # The lower-case hexadecimal character set.
    #
    def Text.lowercase_hexadecimal
      LOWERCASE_HEXADECIMAL
    end

    #
    # The hexadecimal character set.
    #
    def Text.hexadecimal
      HEXADECIMAL
    end

    #
    # The upper-case alpha character set.
    #
    def Text.uppercase_alpha
      UPPERCASE_ALPHA
    end

    #
    # The lower-case alpha character set.
    #
    def Text.lowercase_alpha
      LOWERCASE_ALPHA
    end

    #
    # The alpha character set.
    #
    def Text.alpha
      ALPHA
    end

    #
    # The alpha-numeric character set.
    #
    def Text.alpha_numeric
      ALPHA_NUMERIC
    end

    #
    # The space character set.
    #
    def Text.space
      SPACE
    end

    #
    # The punctuation character set.
    #
    def Text.puncation
      PUNCTUATION
    end

    #
    # The symbolic character set.
    #
    def Text.symbols
      SYMBOLS
    end

    #
    # The control-char character set.
    #
    def Text.control
      CONTROL
    end

    #
    # The ASCII character set.
    #
    def Text.ascii
      ASCII
    end

    #
    # The full 8-bit character set.
    #
    def Text.all
      ALL
    end
  end
end
