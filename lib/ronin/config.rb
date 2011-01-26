#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'env'
require 'data_paths'
require 'fileutils'

module Ronin
  #
  # Configuration information for Ronin.
  #
  module Config
    include DataPaths

    # The users home directory
    HOME = Env.home

    # Ronin home directory
    PATH = HOME.join('.ronin')

    # Configuration files directory
    CONFIG_DIR = PATH.join('config')

    # Directory which repositories are installed into
    REPOS_DIR = PATH.join('repos')

    # Temporary file directory
    TMP_DIR = PATH.join('tmp')

    PATH.mkdir unless PATH.directory?
    CONFIG_DIR.mkdir unless PATH.directory?
    TMP_DIR.mkdir unless TMP_DIR.directory?

    #
    # Loads the Ronin configuration file.
    #
    # @param [Symbol, String, nil] name
    #   The optional name of the file to load within {CONFIG_DIR}.
    #
    # @example Load the config file at `~/.ronin/config.rb`
    #   Config.load
    #   # => true
    #
    # @example Load the config file at `~/.ronin/config/sql.rb`
    #   Config.load :sql
    #   # => true
    #
    def Config.load(name=nil)
      path = if name
               CONFIG_DIR.join("#{name}.rb").expand_path
             else
               PATH.join('config.rb')
             end

      require path if path.file?
    end

    #
    # Auto-creates a directory within {TMP_DIR}.
    #
    # @param [String] sub_path
    #   The sub-path within {TMP_DIR}.
    #
    # @return [Pathname]
    #   The full path within {TMP_DIR}.
    #
    def Config.tmp_dir(sub_path=nil)
      if sub_path
        sub_path = File.expand_path(File.join('',sub_path))
        path = TMP_DIR.join(sub_path)

        path.mkpath unless path.exist?
        return path
      end

      return TMP_DIR
    end
  end
end
