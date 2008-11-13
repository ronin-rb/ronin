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

require 'ronin/chars/char_set'
require 'ronin/chars/chars'

class String

  def in_alphabet?(alphabet)
    each_byte do |b|
      return false unless alphabet.include?(b)
    end

    return true
  end

  def is_numeric?
    in_alphabet?(Ronin::Chars::NUMERIC)
  end

  def is_octal?
    in_alphabet?(Ronin::Chars::OCTAL)
  end

  def is_hexadecimal?
    in_alphabet?(Ronin::Chars::HEXADECIMAL)
  end

  def is_alpha?
    in_alphabet?(Ronin::Chars::ALPHA)
  end

  def is_alpha_numeric?
    in_alphabet?(Ronin::Chars::ALPHA_NUMERIC)
  end

  def is_space?
    in_alphabet?(Ronin::Chars::SPACE)
  end

  def is_punctuation?
    in_alphabet?(Ronin::Chars::PUNCTUATION)
  end

  def is_symbolic?
    in_alphabet?(Ronin::Chars::SYMBOLS)
  end

  def is_control?
    in_alphabet?(Ronin::Chars::CONTROL)
  end

  def is_ascii?
    in_alphabet?(Ronin::Chars::ASCII)
  end

end
