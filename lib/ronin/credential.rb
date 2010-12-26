#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/password'
require 'ronin/model'

module Ronin
  class Credential

    include Model

    # Primary key of the credential
    property :id, Serial

    # Password of the credential
    belongs_to :password

    # User name of the credential
    belongs_to :user_name

    #
    # The user the credential belongs to.
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
    # Converts the credentials to a String.
    #
    # @return [String]
    #   The user name and the password.
    #
    # @since 1.0.0
    #
    def to_s
      "#{self.user_name}:#{self.password}"
    end

    #
    # Splits the credential to multiple variables.
    #
    # @return [Array<String>]
    #   The user and the password.
    #
    # @example
    #   user, password = cred
    #
    #   user
    #   # => "alice"
    #   password
    #   # => "secret"
    #
    # @since 1.0.0
    #
    def to_ary
      [self.user, self.password]
    end

  end
end
