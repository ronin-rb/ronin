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

require 'set'

module Ronin
  module Static
    #
    # @return [Set]
    #   The directories which contain static content.
    #
    def Static.static_dirs
      @@ronin_static_dirs ||= Set[]
    end

    #
    # Adds the path to the Set of static directories.
    #
    # @param [String] path
    #   The path to add to +static_dirs+.
    #
    # @return [String]
    #   The fully qualified form of the specified _path_.
    #
    # @example
    #   Static.directory(File.join(File.dirname(__FILE__),'..','..','..','static'))
    #
    # @raise [RuntimeError] The specified _path_ is not a directory.
    #
    def Static.directory(path)
      path = File.expand_path(path)

      unless File.directory?(path)
        raise(RuntimeError,"#{path.dump} must be a directory")
      end

      Static.static_dirs << path
      return path
    end

    protected

    Static.directory(File.join(File.dirname(__FILE__),'..','..','..','static'))
  end
end
