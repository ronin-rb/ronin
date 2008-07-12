#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/exceptions/invalid_database_config'
require 'ronin/extensions/kernel'
require 'ronin/config'
require 'ronin/models'

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
    DEFAULT_CONFIG = {
      :adapter => :sqlite3,
      :database => File.join(Config::PATH,'ronin.db')
    }

    #
    # Returns the Database configuration that is stored in the
    # +CONFIG_FILE+. Defaults to +DEFAULT_CONFIG+ if +CONFIG_FILE+ does not
    # exist.
    #
    def Database.config
      if File.file?(CONFIG_FILE)
        conf = YAML.load(CONFIG_FILE)

        unless (conf.kind_of?(Hash) || conf.kind_of?(String))
          raise(InvalidDatabaseConfig,"#{CONFIG_FILE} must contain either a Hash or a String",caller)
        end

        return conf
      end

      return DEFAULT_CONFIG
    end

    #
    # Setup the Database log with the given _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:path</tt>:: The path of the log file. Defaults to
    #                  +DEFAULT_LOG_PATH+.
    # <tt>:stream</tt>:: The stream to use for the log.
    # <tt>:level</tt>:: The level of messages to log.
    #
    def Database.setup_log(options={})
      path = (options[:path] || DEFAULT_LOG_PATH)
      stream = (options[:stream] || File.new(path,'w+'))
      level = (options[:level] || DEFAULT_LOG_LEVEL)

      DataMapper::Logger.new(stream,level)
      return nil
    end

    #
    # Sets up the Database with the given _configuration_. If
    # _configuration is not given, +DEFAULT_CONFIG+ will be used to setup
    # the Database.
    #
    def Database.setup(configuration=DEFAULT_CONFIG,&block)
      Database.setup_log
      DataMapper.setup(:default, configuration)

      block.call if block

      DataMapper.auto_upgrade!
      return nil
    end

    Database.setup
  end
end
