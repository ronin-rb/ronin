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
require 'ronin/model/has_name'

module Ronin
  #
  # Represents an author and any information about them or the organization
  # which they belong to.
  #
  class Author

    include Model
    include Model::HasName

    # Primary key of the author
    property :id, Serial

    # Author's associated group
    property :organization, String

    # Author's PGP signature
    property :pgp_signature, Text

    # Author's email
    property :email, String

    # Author's site
    property :site, String

    # Author's biography
    property :biography, Text

    #
    # Converts the author to a String.
    #
    # @return [String]
    #   The name of the author.
    #
    def to_s
      if self.email
        "#{self.name} <#{self.email}>"
      else
        super
      end
    end

  end
end
