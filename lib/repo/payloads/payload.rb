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

require 'payloads/payload'
require 'repo/object'

module Ronin
  module Repo
    class PayloadContext < ObjectContext

      def initialize(path)
	super(path)
      end

      def create
	return Payload.new do |payload|
	  load_payload(payload)
	end
      end

      protected

      # Name of object to load
      attr_object :payload

      # Build action for the payload
      attr_action :builder

      # Clean action for the payload
      attr_action :cleaner

      def load_payload(payload)
	# load payload metadata
	payload.name = name
	payload.version = version

	payload.authors.merge!( authors.values.map { |auth| auth.to_author } )

	payload.params.merge!(params)

	# load payload actions
	cleaner_action = get_action(:cleaner)
	payload.cleaner(&(cleaner_action.block)) if cleaner_action

	builder_action = get_action(:builder)
	payload.builder(&(builder_action.block)) if builder_action
      end

    end
  end
end
