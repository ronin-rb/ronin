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

require 'ronin/credential'
require 'ronin/email_address'
require 'ronin/url'

module Ronin
  class WebCredential < Credential

    # The optional email address the credential is associated with.
    belongs_to :email_address, :required => false

    # The url the credential can be used with.
    belongs_to :url, :required => false,
                     :model => 'URL'

    #
    # Searches all web credentials that are associated with an
    # email address.
    #
    # @param [String] email
    #   The email address to search for.
    #
    # @return [Array<WebCredential>]
    #   The web credentials associated with the email address.
    #
    # @since 1.0.0
    #
    def self.with_email(email)
      unless email.include?('@')
        raise("invalid email address #{email.dump}")
      end

      user, domain = email.split('@',2)

      return all(
        'email_address.user_name.name' => user,
        'email_address.host_name.address' => domain
      )
    end

  end
end
