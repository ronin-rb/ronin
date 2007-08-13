#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'config'

require 'og'

module Ronin
  class ObjectCache

    STORE_PATH = File.join(Config::PATH,'object_cache')

    # Path of the object cache
    attr_reader :path

    # Object cache store
    attr_reader :store

    def initialize(path=STORE_PATH)
      @path = path
      @store = Og.setup(:destroy => false, :evolve_schema => :full, :store => :sqlite, :name => @path)
    end

    protected

    def method_missing(sym,*args)
      @store.send(sym,*args)
    end

  end
end
