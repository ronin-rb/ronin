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

require 'ronin/object_cache'
require 'ronin/console'
require 'ronin/arch'
require 'ronin/platform'
require 'ronin/license'
require 'ronin/product'

module Ronin
  #
  # Load the object_cache from the given _path_.
  #
  #   Ronin.load_object_cache # => ObjectCache
  #
  #   Ronin.load_object_cache("/path/to/cache") # => ObjectCache
  #
  def Ronin.load_object_cache(path=ObjectCache::PATH)
    @object_cache = ObjectCache.new(path)
  end

  #
  # Returns true if object_cache is loaded, returns false otherwise.
  #
  def Ronin.object_cache_loaded?
    !(@object_cache.nil?)
  end

  #
  # Returns the current object-cache, or loads the default object-cache
  # if not already loaded.
  #
  def Ronin.object_cache
    @object_cache = ObjectCache.new
  end

  #
  # Starts Ronin's console with the given _script_. If a _block_ is given
  # it will be ran within the console.
  #
  def Ronin.console(script=nil,&block)
    Console.start(script,&block)
  end

  #
  # Returns the Arch with the matching _name_.
  #
  #   Arch('i686') # => Arch
  #
  def Arch(name)
    Arch.find_by_name(name) || Arch.builtin[name.to_s]
  end

  #
  # Returns the Platform with the matching _os_ and the given _version_.
  # If no platforms exist with the specified _os_ and given _version_, one
  # will be created and returned.
  #
  #   Platform('Linux','2.6.22') # => Platform
  #
  def Platform(os,version=nil)
    Platform.find_with_attributes(:os => os, :version => version).first || Platform.new(os,version)
  end

  #
  # Returns the License with the matching _name_.
  #
  #   License('GPL-2') # => License
  #
  def License(name)
    License.find_by_name(name) || License.builtin[name.to_s]
  end

  #
  # Returns the Product with the matching _name_, _version_ and given
  # _vendor_. If no products exist with the specified _name_, _version_
  # and given _vendor_, one will be created and returned.
  #
  #   Product('vsftpd','2.0.5') # => Product
  #
  def Product(name,version,vendor=name)
    Product.find_with_attributes(:name => name, :version => version, :vendor => vendor).first || Product.new(name,version,vendor)
  end
end
