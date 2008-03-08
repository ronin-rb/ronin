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

require 'ronin/objects'
require 'ronin/console'
require 'ronin/arch'
require 'ronin/platform'
require 'ronin/license'
require 'ronin/product'

module Ronin
  #
  # Load the objects from the given _path_.
  #
  #   Ronin.load_objects # => Objects
  #
  #   Ronin.load_objects("/path/to/cache") # => Objects
  #
  def Ronin.load_objects(path=Objects::PATH)
    Objects.load_cache(path)
  end

  #
  # Returns the current object cache, or loads the default object cache
  # if not already loaded.
  #
  def Ronin.objects
    Objects.cache
  end

  #
  # Starts Ronin's console with the given _script_. If a _block_ is given
  # it will be ran within the console.
  #
  def Ronin.console(script=nil,&block)
    Console.start(script,&block)
  end
end
