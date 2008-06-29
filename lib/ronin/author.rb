#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/model'

require 'rexml/document'
require 'uri'

module Ronin
  class Author

    include Model

    # Anonymouse author name.
    ANONYMOUSE = 'anonymous'

    property :id, Serial

    # Name of author
    property :name, String

    # Author's associated group
    property :organization, String

    # Author's PGP signature
    property :pgp_signature, DataMapper::Types::Text

    # Author's email
    property :email, String

    # Author's site
    property :site, String

    # Author's biography
    property :biography, DataMapper::Types::Text

    #
    # Creates a new Author object with the given _name_ and _info_. The
    # _name_ defaults to ANONYMOUSE. If _block_ is given, it will be passed
    # the newly created Author object.
    #
    # _info_ may contain the following keys:
    # <tt>:organization</tt>:: The organization of the author.
    # <tt>:pgp_signature</tt>:: The PGP signature of the author.
    # <tt>:email</tt>:: The email address of the author.
    # <tt>:url</tt>:: The URL for the author.
    # <tt>:biography</tt>:: The biography of the author.
    #
    def initialize(name=ANONYMOUSE,info={},&block)
      @name = name
      @organization= info[:organization]
      @pgp_signature = info[:pgp_signature]
      @email = info[:email]
      @url = info[:url]
      @biography = info[:biography]

      block.call(self) if block
    end

    #
    # Returns the name of the author.
    #
    def to_s
      @name.to_s
    end

  end
end
