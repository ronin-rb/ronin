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

class Symbol

  #
  # Converts the Symbol to a human readable String.
  #
  # @return [String]
  #   The human readable form the Symbol.
  #
  # @example
  #   :status.humanize
  #   # => "Status"
  #
  #   :cached_timestamp.humanize
  #   # => "Cached Timestamp"
  #
  def humanize
    self.to_s.split('_').map { |part|
      part.capitalize
    }.join(' ')
  end

end
