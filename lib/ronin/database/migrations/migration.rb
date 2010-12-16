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

require 'dm-migrations/migration'

module Ronin
  module Database
    module Migrations
      class Migration < DataMapper::Migration

        # The dependencies of the migration
        attr_reader :needs

        #
        # Creates a new migration.
        #
        # @param [Symbol] name
        #   The name of the migration.
        #
        # @param [Hash] options
        #   Additional options for the migration.
        #
        # @option options [Boolean] :verbose (true)
        #   Enables or disables verbose output.
        #
        # @option options [Symbol] :repository (:default)
        #   The DataMapper repository the migration will operate on.
        #
        # @option options [Array, Symbol] :needs ([])
        #   Other migrations that are dependencies of the migration.
        #
        # @api semipublic
        #
        def initialize(name,options={},&block)
          @needs = Set[*options.fetch(:needs,[])]

          super(0,name,options,&block)
        end

      end
    end
  end
end
