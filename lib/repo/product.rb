#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'product'
require 'repo/objectmetadata'

module Ronin
  module Repo
    class ProductContext

      def initialize(&block)
	# initialize product metadata
	metadata_set(:name)
	metadata_set(:version,"")
	metadata_set(:vendor,"")

	instance_eval(&block)
      end

      def to_product
	Product.new(name,version,vendor)
      end

      protected

      include ObjectMetadata

      # Product name
      attr_metadata :product

      # Product version
      attr_metadata :version

      # Product vendor
      attr_metadata :vendor

    end
  end
end
