#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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

require 'ronin/config'

require 'og'

module Ronin
  class ObjectCache

    # Default path for the object cache.
    PATH = File.join(Config::PATH,'object_cache')

    # Path of the object cache
    attr_reader :path

    # Object cache store
    attr_reader :store

    #
    # Creates a new ObjectCache object with the given _path_. The _path_
    # defaults to PATH. If _block_ is given, it will be passed the newly
    # created ObjectCache object.
    #
    #   ObjectCache.new # => ObjectCache
    #
    #   ObjectCache.new('/path/to/cache') # => ObjectCache
    #
    def initialize(path=PATH,&block)
      @path = path
      @store = Og.setup(:destroy => false, :evolve_schema => true, :store => :sqlite, :name => @path)

      block.call(self) if block
    end

  end
end
