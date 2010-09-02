#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model'

require 'dm-timestamps'

module Ronin
  class UserName

    include Model

    # The primary key of the user-name
    property :id, Serial

    # The name of the user
    property :name, String, :unique => true

    # Tracks when the user-name was created.
    timestamps :created_at

    # Any credentials belonging to the user
    has 0..n, :credentials

    # Email addresses of the user
    has 0..n, :email_addresses

    #
    # Converts the user-name into a String.
    #
    # @return [String]
    #   The name of the user.
    #
    # @since 0.4.0
    #
    def to_s
      self.name.to_s
    end

  end
end
