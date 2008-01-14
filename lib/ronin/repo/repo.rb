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

module Ronin
  module Repo
    #
    # Load the repository cache from the given _path_. If a _block_ is given
    # it will be passed the loaded repository cache.
    #
    #   Repo.load_cache # => Cache
    #
    #   Repo.load_cache('/custom/cache') # => Cache
    #
    def Repo.load_cache(path=Cache::PATH,&block)
      @cache = Cache.new(path,&block)
    end

    #
    # Returns +true+ if the repository cache is loaded, returns +false+
    # otherwise.
    #
    def Repo.cache_loaded?
      !(@cache.nil?)
    end

    #
    # Returns the current repository cache, or loads the default cache
    # if not already loaded.
    #
    def Repo.cache
      @cache ||= Cache.new
    end

    #
    # Load the extension of the specified _name_ from the repository cache.
    # If a _block_ is given, it will be passed the loaded extension.
    #
    #   Repo.extension('payload') # => Extension
    #
    def Repo.extension(name,&block)
      Repo.cache.extension(name,&block)
    end
  end
end
