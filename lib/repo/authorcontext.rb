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

require 'author'
require 'repo/objectmetadata'

module Ronin
  module Repo
    class AuthorContext

      # Name of author
      attr_reader :name

      def initialize(name,&block)
	@name = name.to_s

	# initialize author metadata
	metadata_set(:address)
	metadata_set(:phone)
	metadata_set(:email)
	metadata_set(:site)
	metadata_set(:biography,"")

	instance_eval(&block) if block
      end

      def to_author
	Author.new(@name,biography,{:address => address, :phone => phone, :email => email, :site => site})
      end

      protected

      include ObjectMetadata

      # Author's address
      attr_metadata :address

      # Author's phone
      attr_metadata :phone

      # Author's email
      attr_metadata :email

      # Author's site
      attr_metadata :site

      # Authors biography
      attr_metadata :biography

    end
  end
end
