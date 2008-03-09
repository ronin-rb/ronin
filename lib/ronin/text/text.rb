#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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
    NUMERIC = CharSet.new('0'..'9')

    OCTAL = CharSet.new('0'..'7')

    UPPERCASE_HEXADECIMAL = NUMERIC + ('A'..'F')

    LOWERCASE_HEXADECIMAL = NUMERIC + ('a'..'f')

    HEXADECIMAL = UPPERCASE_HEXADECIMAL + LOWERCASE_HEXADECIMAL

    UPPERCASE_ALPHA = CharSet.new('A'..'Z')

    LOWERCASE_ALPHA = CharSet.new('a'..'z')

    ALPHA = UPPERCASE_ALPHA + LOWERCASE_ALPHA

    ALPHA_NUMERIC = ALPHA + NUMERIC

    SPACE = CharSet.new(' ', "\f", "\n", "\r", "\t", "\v")

    PUNCTUATION = CharSet.new(' ', '\'', '"', '`', ',', ';', ':', '~', '-',
                              '(', ')', '[', ']', '{', '}', '.', '?', '!')

    SYMBOLS = PUNCTUATION + ['@', '#', '$', '%', '^', '&', '*', '_', '+',
                             '=', '|', '\\', '<', '>', '/']

    CONTROL = CharSet.new(0..0x1f, 0x7f)

    ASCII = CharSet.new(0..0x7f)

    ALL = CharSet.new(0..0xff)

    def Text.uppercase_alpha
      UPPERCASE_ALPHA
    end

    def Text.lowercase_alpha
      LOWERCASE_ALPHA
    end

    def Text.alpha
      ALPHA
    end

    def Text.numeric
      NUMERIC
    end

    def Text.octal
      OCTAL
    end

    def Text.uppercase_hexadecimal
      UPPERCASE_HEXADECIMAL
    end

    def Text.lowercase_hexadecimal
      LOWERCASE_HEXADECIMAL
    end

    def Text.hexadecimal
      HEXADECIMAL
    end

    def Text.alpha_numeric
      ALPHA_NUMERIC
    end

    def Text.space
      SPACE
    end

    def Text.puncation
      PUNCTUATION
    end

    def Text.symbols
      SYMBOLS
    end

    def Text.control
      CONTROL
    end

    def Text.ascii
      ASCII
    end

    def Text.all
      ALL
    end
  end
end
