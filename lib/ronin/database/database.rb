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

require 'ronin/database/exceptions/invalid_config'
require 'ronin/database/exceptions/unknown_repository'
require 'ronin/model'
require 'ronin/config'

require 'addressable/uri'
require 'yaml'
require 'dm-core'

module Ronin
  #
  # Manages the {Database} configuration and the defined repositories.
  # Also provides a simple wrapper around `DataMapper`, for initializing,
  # auto-upgrading and querying {Database} repositories.
  #
  module Database
    # Database configuration file
    CONFIG_FILE = File.join(Config::PATH,'database.yml')

    # Database log file
    DEFAULT_LOG_PATH = File.join(Config::PATH,'database.log')

    # Database log level
    DEFAULT_LOG_LEVEL = :info

    # Default database repository
    DEFAULT_REPOSITORY = Addressable::URI.new(
      :scheme => 'sqlite3',
      :path => File.join(Config::PATH,'database.sqlite3')
    )

    #
    # Returns the Database repositories to use.
    #
    # @return [Hash{Symbol => Addressable::URI}]
    #   The database repository names and URIs.
    #
    # @raise [InvalidConfig]
    #   The config file did not contain a YAML Hash.
    #
    # @since 0.4.0
    #
    def Database.repositories
      unless class_variable_defined?('@@ronin_database_repositories')
        @@ronin_database_repositories = {
          :default => DEFAULT_REPOSITORY
        }

        if File.file?(CONFIG_FILE)
          conf = YAML.load_file(CONFIG_FILE)

          unless conf.kind_of?(Hash)
            raise(InvalidConfig,"#{CONFIG_FILE} must contain a YAML Hash of repositories",caller)
          end

          conf.each do |name,uri|
            @@ronin_database_repositories[name.to_sym] = Addressable::URI.parse(uri)
          end
        end
      end

      return @@ronin_database_repositories
    end

    #
    # Determines if the Database provides a specific repository.
    #
    # @param [String, Symbol] name
    #   Name of the repository.
    #
    # @return [Boolean]
    #   Specifies if the Database provides the repository.
    #
    # @since 0.4.0
    #
    def Database.repository?(name)
      Database.repositories.has_key?(name.to_sym)
    end

    #
    # Saves the Database configuration to `CONFIG_FILE`.
    #
    # @yield []
    #   If a block is given, it will be called before the database
    #   configuration is saved.
    #
    # @return [true]
    #
    # @since 0.4.0
    #
    def Database.save(&block)
      block.call() if block

      File.open(CONFIG_FILE,'w') do |file|
        hash = {}
        
        Database.repositories.each do |name,value|
          hash[name.to_s] = value.to_s
        end

        YAML.dump(hash,file)
      end

      return true
    end

    #
    # @return [DataMapper::Logger, nil]
    #   The current Database log.
    #
    def Database.log
      @@ronin_database_log ||= nil
    end

    #
    # Setup the Database log.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :path (DEFAULT_LOG_PATH)
    #   The path of the log file.
    #
    # @option options [IO] :stream
    #   The stream to use for the log.
    #
    # @option options [Symbol] :level
    #   The level of messages to log.
    #   May be either `:fatal`, `:error`, `:warn`, `:info` or `:debug`.
    #
    # @return [DataMapper::Logger]
    #   The new Database log.
    #
    def Database.setup_log(options={})
      path = (options[:path] || DEFAULT_LOG_PATH)
      stream = (options[:stream] || File.new(path,'w+'))
      level = (options[:level] || DEFAULT_LOG_LEVEL)

      return @@ronin_database_log = DataMapper::Logger.new(stream,level)
    end

    #
    # Determines if a specific database repository is setup.
    #
    # @param [Symbol] name
    #   The database repository name.
    #
    # @return [Boolean]
    #   Specifies wether or not the Database is setup.
    #
    def Database.setup?(name=:default)
      repository = DataMapper.repository(name)

      return repository.class.adapters.has_key?(repository.name)
    end

    #
    # Updates the Database, by running auto-upgrades, but only if the
    # Database is already setup.
    #
    # @yield []
    #   The block to call before the Database is updated.
    #
    # @return [nil]
    #
    def Database.upgrade(&block)
      block.call() if block

      Database.repositories.each_key do |name|
        DataMapper.auto_upgrade!(name) if Database.setup?(name)
      end

      return nil
    end

    #
    # Sets up the Database.
    #
    # @yield []
    #   The block to call after the Database has been setup, but before
    #   it is updated.
    #
    # @see Database.upgrade
    #
    def Database.setup(&block)
      # setup the database log
      Database.setup_log unless Database.log

      # setup the database repositories
      Database.repositories.each do |name,uri|
        DataMapper.setup(name,uri)
      end

      # auto-upgrade the database repository
      Database.upgrade(&block)
    end

    #
    # Performs Database transactions within a given repository.
    #
    # @param [String, Symbol] name
    #   The name of the repository to access.
    #
    # @return [DataMapper::Repository]
    #   The Database repository.
    #
    # @raise [UnknownRepository]
    #   The specified Database repository is unknown.
    #
    # @since 0.4.0
    #
    def Database.repository(name,&block)
      name = name.to_sym

      unless Database.repository?(name)
        raise(UnknownRepository,"unknown database repository #{name}",caller)
      end

      return DataMapper.repository(name,&block)
    end

    #
    # Clears the Database, by running destructive auto-migrations.
    #
    # @param [String, Symbol] name
    #   The name of the Database repository to clear.
    #
    # @yield []
    #   If a block is given, it will be called after the Database
    #   repository has been cleared.
    #
    # @return [nil]
    #
    # @raise [UnknownRepository]
    #   The specified Database repository is unknown.
    #
    # @since 0.4.0
    #
    def Database.clear(name,&block)
      name = name.to_sym

      unless Database.repository?(name)
        raise(UnknownRepository,"unknown database repository #{name}",caller)
      end

      DataMapper.auto_migrate!(name)

      block.call() if block
      return nil
    end

    #
    # Performs Database transactions in each of the Database
    # repositories.
    #
    # @yield []
    #   The given block will be ran within the context of each Database
    #   repository.
    #
    # @return [Array]
    #   The results from each database transaction.
    #
    # @since 0.4.0
    #
    def Database.map(&block)
      results = []

      Database.repositories.each_key do |name|
        DataMapper.repository(name) do
          result = block.call()
          results << result unless result.nil?
        end
      end

      return results
    end
  end
end
