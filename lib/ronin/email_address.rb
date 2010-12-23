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

require 'ronin/user_name'
require 'ronin/host_name'
require 'ronin/model'

require 'dm-timestamps'

module Ronin
  class EmailAddress

    include Model

    # The primary key of the email address
    property :id, Serial

    # The user-name component of the email address
    belongs_to :user_name, :unique => :user_host

    # The host-name component of the email address
    belongs_to :host_name, :unique => :user_host

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
    # @since 1.0.0
    #
    def EmailAddress.parse(email)
      user, host = email.strip.split('@',2)

      return EmailAddress.first_or_new(
        :user_name => UserName.first_or_new(:name => user),
        :host_name => HostName.first_or_new(:address => host)
      )
    end

    #
    # The user of the email address.
    #
    # @return [String]
    #   The user name.
    #
    # @since 1.0.0
    #
    def user
      self.user_name.name if self.user_name
    end

    #
    # The host of the email address.
    #
    # @return [String]
    #   The host name.
    #
    # @since 1.0.0
    #
    def host
      self.host_name.address if self.host_name
    end

    #
    # Converts the email address into a String.
    #
    # @return [String]
    #   The raw email address.
    #
    # @since 1.0.0
    #
    def to_s
      "#{self.user_name}@#{self.host_name}"
    end

    #
    # Splats the email address into multiple variables.
    #
    # @return [Array]
    #   The user-name and the host-name within the email address.
    #
    # @example
    #   email = EmailAddress.parse('alice@example.com')
    #   user, host = email
    #   
    #   user
    #   # => "alice"
    #   host
    #   # => "example.com"
    #
    # @since 1.0.0
    #
    def to_ary
      [self.user_name.name, self.host_name.address]
    end

  end
end
