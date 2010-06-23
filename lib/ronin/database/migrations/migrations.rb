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
      #
      # The registered database migrations.
      #
      # @return [Hash{Symbol => Hash{String => Array<DataMapper::Migration>}}]
      #   Database migrations grouped by library name and version.
      #
      # @since 0.4.0
      #
      def Migrations.migrations
        @ronin_database_migrations ||= {}
      end

      #
      # Enumerates over the migrations for a library.
      #
      # @param [Symbol] library
      #   The name of the library.
      #
      # @param [String] lib_version
      #   The optional version of the library.
      #
      # @yield [migration]
      #   The given block will be passed each migration for the library.
      #
      # @yieldparam [DataMapper::Migration] migration
      #   A database migration.
      #
      def Migrations.each(library,lib_version=nil,&block)
        library = library.to_sym

        unless Migrations.migrations.has_key?(library)
          raise(RuntimeError,"unknown library to migration #{library}",caller)
        end

        library_migrations = Migrations.migrations[library]

        if lib_version
          lib_version = lib_version.to_s

          unless library_migrations.has_key?(lib_version)
            raise(RuntimeError,"unknown version to migrate #{lib_version} for #{library}",caller)
          end

          library_migrations.each do |version,version_migrations|
            version_migration.each(&block) if version <= lib_version
          end
        else
          library_migrations.each do |version,version_migrations|
            version_migrations.each(&block)
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
      def Migrations.migrate_up!(library,lib_version=nil)
        Migrations.each(library,lib_version) { |migration| migration.perform_up }
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
      def Migrations.migrate_down!(library,lib_version=nil)
        Migrations.each(library,lib_version) { |migration| migration.perform_down }
      end

      protected

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
        version = version.to_s
        migration_name = "#{library}-#{version}_#{name}"

        Migrations.migrations[library] ||= {}
        Migrations.migrations[library][version] ||= []

        if Migrations.migrations[library][version].any? { |migration| migration.name == migration_name }
          raise(DataMapper::DuplicateMigrationNameError,"migration name conflict: #{migration_name}",caller)
        end

        position = Migrations.migrations[library][version].length
        new_migration = DataMapper::Migration.new(position,migration_name,&block)

        Migrations.migrations[library][version] << new_migration
        return new_migration
      end
    end
  end
end
