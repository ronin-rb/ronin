#
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#

class Array

  #
  # Decodes the bytes contained within the Array. The Array may contain
  # both Integer and String objects.
  #
  # @return [Array] The bytes contained in the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].bytes
  #   # => [0x41, 0x41, 0x20]
  #
  # @example
  #   ['A', 'BB', 0x90].bytes
  #   # => [0x41, 0x42, 0x42, 0x90]
  #
  def bytes
    self.inject([]) do |accum,elem|
      if elem.kind_of?(Integer)
        accum << elem
      else
        elem.to_s.each_byte { |b| accum << b }
      end

      accum
    end
  end

  #
  # Decodes the characters contained within the Array. The Array may contain
  # either Integer or String objects.
  #
  # @return [Array] The characters generated from the array.
  #
  # @example
  #   [0x41, 0x41, 0x20].chars
  #   # => ["A", "A", " "]
  #
  def chars
    self.bytes.map { |b| b.chr }
  end

  #
  # @return [String] The String created from the characters within the Array.
  #
  # @example
  #   [0x41, 0x41, 0x20].char_string
  #   # => "AA "
  #
  def char_string
    chars.join
  end

end
