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

require 'ronin/ui/output/output'

require 'dm-core'
require 'dm-migrations/migration'

module Ronin
  module Database
    class Migration < DataMapper::Migration

      # The library the migration is for.
      attr_reader :library

      # The version of the library.
      attr_reader :version

      # A short description of the migration.
      attr_reader :description

      #
      # Creates a new {Database} migration.
      #
      # @param [Integer] index
      #   The index of the migration.
      #
      # @param [Symbol] library
      #   The library the migration is for.
      #
      # @param [Gem::Version] version
      #   The version of the library.
      #
      # @param [Symbol] name
      #   A short description of the migration.
      #
      # @since 0.4.0
      #
      def initialize(index,library,version,name,options={},&block)
        @library = library
        @version = version
        @description = name

        options = options.merge(:verbose => UI::Output.verbose?)

        super(index,"#{library}-#{version}-#{name}",options,&block)
      end

    end
  end
end
