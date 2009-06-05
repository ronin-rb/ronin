#
#--
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
#++
#

class Array

  #
  # Returns the Array of characters generated from the array.
  #
  #   [0x41, 0x41, 0x20].chars
  #   # => ["A", "A", " "]
  #
  def chars
    self.map { |b| b.to_i.chr }
  end

  #
  # Returns the String created from the characters within the array.
  #
  #   [0x41, 0x41, 0x20].char_string
  #   # => "AA "
  #
  def char_string
    chars.join
  end

end
