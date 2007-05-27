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

require 'advisory'
require 'repo/object'
require 'repo/product'

module Ronin
  module Repo
    class AdvisoryContext < ObjectContext

      def initialize(path)
	# initialize advisory metadata
	metadata_set(:class)
	metadata_set(:cve)
	metadata_set(:remote,false)
	metadata_set(:local,false)
	metadata_set(:published,"")
	metadata_set(:updated,"")
	metadata_set(:credits,"")
	metadata_set(:comments,"")

	# Product context list
	@products = []

	super(path)
      end

      def create
	return Advisory.new do |adv|
	  adv.classification = classification
	  adv.cve = cve
	  adv.remote = remote
	  adv.local = local
	  adv.published = published
	  adv.updated = updated
	  adv.credits = credits

	  @products.each { |product| adv.add_product(product.to_product) }

	  adv.comments = comments
	end
      end

      protected

      # Name of object to load
      attr_object :advisory

      # Vulnerability class
      attr_metadata :class
      
      # CVE
      attr_metadata :cve

      # Remote?
      attr_metadata :remote

      # Local?
      attr_metadata :local

      # Date published
      attr_metadata :published

      # Date updated
      attr_metadata :updated

      # Credits
      attr_metadata :credits
      
      # Comments
      attr_metadata :comments

      def product(&block)
	@products << ProductContext.new(&block)
      end

    end
  end
end
