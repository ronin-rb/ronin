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

require 'ronin/address'
require 'ronin/model'
require 'ronin/model/has_name'
require 'ronin/model/has_description'

require 'dm-timestamps'
require 'dm-tags'

module Ronin
  class Organization

    include Model
    include Model::HasName
    include Model::HasDescription

    # Primary key of the organization
    property :id, Serial

    # The addresses that belong to the organization
    has 1..n, :addresses

    # Tracks when the organization was first created
    timestamps :created_at

    # Tags
    has_tags_on :tags

    #
    # Converts the Organization to a String.
    #
    # @return [String]
    #   The name of the organization.
    #
    # @since 1.0.0
    #
    def to_s
      self.name.to_s
    end

  end
end
