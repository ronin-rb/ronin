#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'scanf'

class String

  #
  # Returns the HTML decimal encoded form of the string.
  #
  #   "hello".html_dec_encode # => "&#104;&#101;&#108;&#108;&#111;"
  #
  def html_dec_encode
    output = ''

    self.each_byte { |c| output+=sprintf("&#%d;",c) }
    return output
  end

  #
  # Returns the HTML decimal decoded form of the string.
  #
  #   "&#99;&#111;&#102;&#102;&#101;&#101;" # => "coffee"
  #
  def html_dec_decode
    self.block_scanf('&#%d;') { |c| input+=c[0].chr }.join
  end

  #
  # Returns the HTML hexidecimal encoded form of the string.
  #
  #   "hello" # => "&#68;&#65;&#6C;&#6C;&#6F;"
  #
  def html_hex_encode
    output = ''

    self.each_byte { |c| output+=sprintf("&#%X;",c) }
    return output
  end

  #
  # Returns the HTML hexidecimal decoded form of the string.
  #
  #   "&#72;&#75;&#62;&#79;" # => "ruby"
  #
  def html_hex_decode
    self.block_scanf('&#%X;') { |c| input+=c[0].chr }.join
  end

end
