#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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
#++
#

require 'fileutils'

module Ronin
  module Config
    # The users home directory
    HOME = File.expand_path(ENV['HOME'] || ENV['HOMEPATH'])

    # Ronin home directory
    PATH = FileUtils.mkdir_p(File.join(HOME,'.ronin'))

    # Path to static directory
    STATIC_DIR = File.expand_path(File.join(File.dirname(__FILE__),'..','..','static'))

    # Main configuration file
    CONFIG_PATH = File.join(PATH,'config.rb')

    # Configuration files directory
    CONFIG_DIR = FileUtils.mkdir_p(File.join(PATH,'config'))

    # Temporary file directory
    TMP_DIR = FileUtils.mkdir_p(File.join(PATH,'tmp'))

    #
    # Require the Ronin configuration file with the given _name_ in the
    # Ronin configuration files directory. If _name_ is not given, than the
    # main Ronin configuration file will be loaded.
    #
    # Load the main config file at <tt>~/.ronin/config.rb</tt>
    #
    #   Config.load
    #   # => true
    #
    # Load a specific config file in <tt>~/.ronin/config/</tt>
    #
    #   Config.load :sql
    #   # => true
    #
    def Config.load(name=nil)
      if name
        path = File.expand_path(File.join(CONFIG_DIR,name.to_s))
      else
        path = CONFIG_PATH
      end

      require path if File.file?(path)
    end
  end
end
