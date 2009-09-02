#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/model'
require 'ronin/arch'
require 'ronin/os'
require 'ronin/author'
require 'ronin/license'
require 'ronin/product'
require 'ronin/config'

require 'yaml'
require 'dm-core'

module Ronin
  module Database
    # Database configuration file
    CONFIG_FILE = File.join(Config::PATH,'database.yml')

    # Database log file
    DEFAULT_LOG_PATH = File.join(Config::PATH,'database.log')

    # Database log level
    DEFAULT_LOG_LEVEL = :info

    # Default configuration of the database
    DEFAULT_CONFIG = "sqlite3://" + File.join(Config::PATH,'database.sqlite3')

    #
    # Returns the Database configuration that is stored in the
    # +CONFIG_FILE+. Defaults to +DEFAULT_CONFIG+ if +CONFIG_FILE+ does not
    # exist.
    #
    # @raise [InvalidConfig] The config file did not contain a YAML Hash or
    #                        String.
    #
    def Database.config
      unless (class_variable_defined?('@@ronin_database_config'))
        @@ronin_database_config = DEFAULT_CONFIG

        if File.file?(CONFIG_FILE)
          conf = YAML.load(CONFIG_FILE)

          unless (conf.kind_of?(Hash) || conf.kind_of?(String))
            raise(InvalidConfig,"#{CONFIG_FILE} must contain either a Hash or a String",caller)
          end

          @@ronin_database_config = conf
        end
      end

      return @@ronin_database_config ||= DEFAULT_CONFIG
    end

    #
    # Sets the Database configuration.
    #
    # @param [String, Hash] configuration The DataMapper configuration to
    #                                     set the Ronin::Database with.
    #
    def Database.config=(configuration)
      @@ronin_database_config = configuration
    end

    #
    # @return [DataMapper::Logger, nil] The current Database log.
    #
    def Database.log
      @@ronin_database_log ||= nil
    end

    #
    # Setup the Database log.
    #
    # @param [Hash] options Additional options.
    # @option options [String] :path (DEFAULT_LOG_PATH)
    #                                The path of the log file.
    # @option options [IO] :stream The stream to use for the log.
    # @option options [Symbol] :level The level of messages to log.
    #                                 May be either +:fatal+, +:error+,
    #                                 +:warn+, +:info+ or +:debug+.
    #
    # @return [DataMapper::Logger] The new Database log.
    #
    def Database.setup_log(options={})
      path = (options[:path] || DEFAULT_LOG_PATH)
      stream = (options[:stream] || File.new(path,'w+'))
      level = (options[:level] || DEFAULT_LOG_LEVEL)

      return @@ronin_database_log = DataMapper::Logger.new(stream,level)
    end

    #
    # @return [true, false] Specifies wether or not the Database is setup.
    #
    def Database.setup?
      repository = DataMapper.repository(Model::REPOSITORY_NAME)

      return repository.class.adapters.has_key?(repository.name)
    end

    #
    # Updates the Database, by running auto-upgrades, but only if the
    # Database is already setup.
    #
    # @yield [] The block to call before the Database is updated.
    #
    def Database.update!(&block)
      block.call if block

      DataMapper.auto_upgrade!(Model::REPOSITORY_NAME) if Database.setup?
      return nil
    end

    #
    # Sets up the Database.
    #
    # @param [String, Hash] configuration The DataMapper configuration to
    #                                     use to setup the Database.
    # 
    # @yield [] The block to call after the Database has been setup, but
    #           before it is updated.
    #
    def Database.setup(configuration=Database.config,&block)
      # setup the database log
      Database.setup_log unless Database.log

      # setup the database repository
      DataMapper.setup(Model::REPOSITORY_NAME, configuration)

      Database.update!(&block)
      return nil
    end
  end
end
