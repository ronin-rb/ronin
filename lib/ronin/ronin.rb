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

require 'ronin/environment'
require 'ronin/objectcache'
require 'ronin/arch'
require 'ronin/platform'
require 'ronin/license'
require 'ronin/product'

module Ronin
  # Ronin Environment constant
  RONIN_ENV = Environment.new

  # Load the specified object cache
  def Ronin.load_object_cache(path=ObjectCache::STORE_PATH)
    @object_cache = ObjectCache.new(path)
  end

  # Is the object cache loaded?
  def Ronin.object_cache_loaded?
    !(@object_cache.nil?)
  end

  # Load the default object cache
  def Ronin.object_cache
    @object_cache = ObjectCache.new
  end

  def Arch(name)
    Arch.find_by_name(name) || Arch.builtin[name.to_s]
  end

  def Platform(os,version=nil)
    Platform.find_with_attributes(:os => os, :version => version).first || Platform.new(os,version)
  end

  def License(name)
    License.find_by_name(name) || License.builtin[name.to_s]
  end

  def Product(name,version,vendor=name)
    Product.find_with_attributes(:name => name, :version => version, :vendor => vendor).first || Product.new(name,version,vendor)
  end
end
