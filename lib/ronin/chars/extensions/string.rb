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

require 'ronin/chars/chars'

class String

  #
  # Returns +true+ if all of the bytes within the string exist within the
  # specified _alphabet_, returns +false+ otherwise. If the string is empty
  # +false+ will also be returned.
  #
  def in_alphabet?(alphabet)
    return false if empty?

    each_byte do |b|
      return false unless alphabet.include?(b)
    end

    return true
  end

  #
  # Returns +true+ if the string is numeric, returns +false+ otherwise.
  #
  def is_numeric?
    in_alphabet?(Ronin::Chars::NUMERIC)
  end

  #
  # Returns +true+ if the string is octal, returns +false+ otherwise.
  #
  def is_octal?
    in_alphabet?(Ronin::Chars::OCTAL)
  end

  #
  # Returns +true+ if the string is hexadecimal, returns +false+ otherwise.
  #
  def is_hexadecimal?
    in_alphabet?(Ronin::Chars::HEXADECIMAL)
  end

  #
  # Returns +true+ if the string is alpha, returns +false+ otherwise.
  #
  def is_alpha?
    in_alphabet?(Ronin::Chars::ALPHA)
  end

  #
  # Returns +true+ if the string is alpha-numeric, returns +false+ otherwise.
  #
  def is_alpha_numeric?
    in_alphabet?(Ronin::Chars::ALPHA_NUMERIC)
  end

  #
  # Returns +true+ if the string only contains space characters, returns
  # +false+ otherwise.
  #
  def is_space?
    in_alphabet?(Ronin::Chars::SPACE)
  end

  #
  # Returns +true+ if the string only contains punctuation characters,
  # returns +false+ otherwise.
  #
  def is_punctuation?
    in_alphabet?(Ronin::Chars::PUNCTUATION)
  end

  #
  # Returns +true+ if the string only contains symbolic characters,
  # returns +false+ otherwise.
  #
  def is_symbolic?
    in_alphabet?(Ronin::Chars::SYMBOLS)
  end

  #
  # Returns +true+ if the string only contains control characters,
  # returns +false+ otherwise.
  #
  def is_control?
    in_alphabet?(Ronin::Chars::CONTROL)
  end

  #
  # Returns +true+ if the string only contains ASCII characters,
  # returns +false+ otherwise.
  #
  def is_ascii?
    in_alphabet?(Ronin::Chars::ASCII)
  end

end
