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

require 'ronin/formating/extensions/text'

require 'scanf'
require 'cgi'

class String

  def html_encode
    CGI.escapeHTML(self)
  end

  #
  # Returns the HTML decimal decoded form of the string.
  #
  #   "&lt;rock on&gt;".html_decode # => "<rock on>"
  #
  #   "&#99;&#111;&#102;&#102;&#101;&#101;".html_decode # => "coffee"
  #
  def html_decode
    CGI.unescapeHTML(self)
  end

  #
  # Returns the HTML decimal encoded form of the string.
  #
  #   "hello".format_html # => "&#104;&#101;&#108;&#108;&#111;"
  #
  def format_html(options={})
    format_bytes(options) { |c| sprintf("&#%d;",c) }
  end

end
