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

require 'data_mapper'

module Ronin
  class Objects

    # Default path for the object cache.
    PATH = File.join(Config::PATH,'objects.db')

    # Default DataMapper adapter
    ADAPTER = 'sqlite3'

    # Path to the object cache
    attr_reader :path

    # Database Adapter for the object cache
    attr_reader :adapter

    def initialize(path=PATH,&block)
      @path = path
      @adapter = DataMapper::Database.setup({:adapter => ADAPTER,
                                             :database => path})

      block.call(self) if block
    end

    def Objects.load_cache(path=PATH,&block)
      @@cache = Objects.new(path,&block)
    end

    def Objects.cache
      @@cache ||= Objects.new(PATH)
    end

  end
end
