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

require 'ronin/model'

require 'rexml/document'
require 'uri'

module Ronin
  class Author

    include Model

    # Anonymouse author name
    ANONYMOUSE = 'Anonymous'

    # Primary key of the author
    property :id, Serial

    # Name of author
    property :name, String, :index =>  true

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
    # Creates a new Author object with the given _options_. If _block_ is
    # given, it will be passed the newly created Author object.
    #
    # @param [Hash] options Additional options.
    # @option options [String] :name (ANONYMOUSE) The name of the author.
    # @option options [String] :organization The organization the author
    #                                        belongs to.
    # @option options [String] :pgp_signature The PGP fingerprint of the
    #                                         author.
    # @option options [String] :email The email to contact the author.
    # @option options [String] :url The URL of the author.
    # @option options [String] :biography The biography of the author.
    #
    def initialize(options={},&block)
      super(options)

      block.call(self) if block
    end

    #
    # Converts the author to a String.
    #
    # @return [String] The name of the author.
    #
    def to_s
      self.name.to_s
    end

  end
end
