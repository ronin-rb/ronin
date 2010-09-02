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
require 'ronin/user_name'
require 'ronin/host_name'

require 'dm-timestamps'

module Ronin
  class EmailAddress

    include Model

    # The primary key of the email address
    property :id, Serial

    # The user-name component of the email address
    belongs_to :user_name

    # The host-name component of the email address
    belongs_to :host_name

    # Tracks when the email address was created at.
    timestamps :created_at

    #
    # Parses an email address.
    #
    # @param [String] email
    #   The email address to parse.
    #
    # @return [EmailAddress]
    #   A new or previously saved email address resource.
    #
    # @since 0.4.0
    #
    def EmailAddress.parse(email)
      user_name, host_name = email.strip.split('@',2)

      EmailAddress.first_or_new(
        EmailAddress.user_name.name => user_name,
        EmailAddress.host_name.address => host_name
      )
    end

    #
    # Converts the email address into a String.
    #
    # @return [String]
    #   The raw email address.
    #
    # @since 0.4.0
    #
    def to_s
      "#{self.user_name}@#{self.host_name}"
    end

  end
end
