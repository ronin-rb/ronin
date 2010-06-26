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

require 'dm-core'
require 'dm-types'
require 'dm-migrations/migration'
require 'dm-migrations/property_constants'

require 'enumerator'
require 'rubygems/version'

module Ronin
  module Database
    module Migrations
      include DataMapper::Migrations::PropertyConstants

      #
      # The registered database migrations.
      #
      # @return [Hash{Symbol => Hash{String => Hash{Symbol => Proc}}}]
      #   Database migrations grouped by library name and version.
      #
      # @since 0.4.0
      #
      def Migrations.migrations
        @ronin_database_migrations ||= {}
      end

      #
      # Iterates over the migrations for a specific version of a library.
      #
      # @param [Symbol] library
      #   The name of the library.
      #
      # @param [String] version
      #   The version of the library.
      #
      # @yield [migration]
      #   The given block will be passed each migration.
      #
      # @yieldparam [DataMapper::Migration] migration
      #   A DataMapper migration.
      #
      # @return [Enumerator]
      #   Returns an enumerator object if no block was given.
      #
      # @since 0.4.0
      #
      def Migrations.each(library,version)
        return enum_for(:each,library,version) unless block_given?

        Migrations.migrations[library][version].each_with_index do |(name,block),index|
          Database.repositories.each_key do |repo|
            yield DataMapper::Migration.new(index,"#{library}-#{version}-#{name}",:database => repo,&block)
          end
        end
      end

      #
      # Migrates the database upwards for a library.
      #
      # @param [Symbol] library
      #   The name of the library.
      #
      # @param [String] lib_version
      #   The optional version of the library.
      #
      # @return [true]
      #   Specifies that the migration was successful.
      #
      # @since 0.4.0
      #
      def Migrations.migrate_up!(library,lib_version=nil)
        library = library.to_sym

        unless Migrations.migrations.has_key?(library)
          raise(RuntimeError,"unknown library to migrate #{library}",caller)
        end

        if lib_version
          lib_version = Gem::Version.new(lib_version)
        end

        Migrations.migrations[library].each_key do |version|
          # migrate up all versions less or equal to the desired version
          if (lib_version.nil? || (version <= lib_version))
            Migrations.each(library,version) do |migration|
              migration.perform_up
            end
          end
        end
      end

      #
      # Migrates the database downwards for a library.
      #
      # @param [Symbol] library
      #   The name of the library.
      #
      # @param [String] lib_version
      #   The optional version of the library.
      #
      # @return [true]
      #   Specifies that the migration was successful.
      #
      # @since 0.4.0
      #
      def Migrations.migrate_down!(library,lib_version)
        library = library.to_sym

        unless Migrations.migrations.has_key?(library)
          raise(RuntimeError,"unknown library to migrate #{library}",caller)
        end

        lib_version = Gem::Version.new(lib_version)

        # note the usage of reverse_each
        Migrations.migrations[library].keys.reverse_each do |version|
          # migrate down all versions greater than the desired version
          if version > lib_version
            Migrations.each(library,version).reverse_each do |migration|
              migration.perform_down
            end
          end
        end

        return true
      end

      protected

      # XXX: hack to override the global URI constant only within migrations.
      DataMapper::Migration.class_eval do
        URI = DataMapper::Property::URI
      end

      #
      # Registers a database migration.
      #
      # @param [Symbol] library
      #   The name of the library that needs the migration.
      #
      # @param [String] version
      #   The version of the migration that needs the migration.
      #
      # @param [Symbol] name
      #   The descriptive name of the migration.
      #
      # @yield []
      #   The given block will contain the migration logic.
      #
      # @return [DataMapper::Migration]
      #   The database migration.
      #
      # @since 0.4.0
      #
      def Migrations.migration(library,version,name,&block)
        library = library.to_sym
        version = Gem::Version.new(version)
        name = name.to_sym

        Migrations.migrations[library] ||= {}
        Migrations.migrations[library][version] ||= {}

        if Migrations.migrations[library][version].has_key?(name)
          raise(DataMapper::DuplicateMigrationNameError,"migration name conflict: #{name} for #{library}-#{version}",caller)
        end

        Migrations.migrations[library][version][name] = block
        return true
      end
    end
  end
end
