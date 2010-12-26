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

require 'ronin/organization'
require 'ronin/target'
require 'ronin/model'

require 'dm-timestamps'
require 'dm-tags'

module Ronin
  class Address

    include Model

    # The primary key of the Address
    property :id, Serial

    # The class name of the Address
    property :type, Discriminator

    # The Address
    property :address, String, :required => true,
                               :unique => true

    # The optional organization the host belongs to
    belongs_to :organization, :required => false

    # The targets associated with the address
    has 0..n, :targets

    # The remote files associated with the address
    has 0..n, :remote_files, :through => :targets

    # The campaigns targeting the address
    has 0..n, :campaigns, :through => :targets

    # Tracks when the IP Address was first created
    timestamps :created_at

    # Tags
    has_tags_on :tags

  end
end
