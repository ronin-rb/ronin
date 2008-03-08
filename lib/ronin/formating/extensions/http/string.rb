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

require 'uri'
require 'cgi'

class String

  #
  # Returns the URI encoded form of the string.
  #
  #   "artful wall".uri_encode # => "artful%20wall"
  #
  def uri_encode
    URI.encode(self)
  end

  #
  # Returns the URI decoded form of the string.
  #
  #   "genre%3f".uri_encode # => "genre?"
  #
  def uri_decode
    URI.decode(self)
  end

  def uri_escape
    CGI.escape(self)
  end

  def uri_unescape
    CGI.unescape(self)
  end

end
