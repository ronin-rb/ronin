#
# Ronin - A Ruby platform for exploit development and security research.
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

require 'ronin/formatting/extensions/text'

require 'uri'
require 'cgi'

class String

  #
  # @return [String] The URI encoded form of the String.
  #
  # @example
  #   "art is graffiti".uri_encode
  #   # => "art%20is%20graffiti"
  #
  def uri_encode
    URI.encode(self)
  end

  #
  # @return [String] The decoded URI form of the String.
  #
  # @example
  #   "genre%3f".uri_decode
  #   # => "genre?"
  #
  def uri_decode
    URI.decode(self)
  end

  #
  # @return [String] The URI escaped form of the String.
  #
  # @example
  #   "x > y".uri_escape
  #   # => "x+%3E+y"
  #
  def uri_escape
    CGI.escape(self)
  end

  #
  # @return [String] The unescaped URI form of the String.
  #
  # @example
  #   "sweet+%26+sour".uri_unescape
  #   # => "sweet & sour"
  #
  def uri_unescape
    CGI.unescape(self)
  end

  #
  # @return [String] The HTTP hexidecimal encoded form of the String.
  #
  # @example
  #   "hello".format_http
  #   # => "&#104;&#101;&#108;&#108;&#111;"
  #
  def format_http(options={})
    format_bytes(options) { |b| "%%%x" % b }
  end

end
