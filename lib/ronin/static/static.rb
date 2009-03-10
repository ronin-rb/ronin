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

require 'set'

module Ronin
  module Static
    #
    # The Set of directories which contain static content.
    #
    def Static.static_dirs
      @@ronin_static_dirs ||= Set[]
    end

    #
    # Adds the specified _path_ to the Set of static directories.
    #
    def Static.directory(path)
      path = File.expand_path(path)

      unless File.directory?(path)
        raise("#{path.dump} must be a directory")
      end

      Static.static_dirs << path
      return path
    end

    protected

    Static.directory(File.join(File.dirname(__FILE__),'..','..','..','static'))
  end
end
