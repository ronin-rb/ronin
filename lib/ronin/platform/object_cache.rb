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

require 'ronin/extensions/kernel'
require 'ronin/database'
require 'ronin/cacheable'

module Ronin
  module Platform
    module ObjectCache
      #
      # Searches for object files within the specified _directory_.
      #
      # @param [String] directory
      #   The directory to search for object files within.
      #
      # @return [Array]
      #   All paths within the specified _directory_ pointing to object
      #   files.
      #
      def ObjectCache.paths(directory)
        Dir[File.join(File.expand_path(directory),'**','*.rb')]
      end

      #
      # Finds all cached objects.
      #
      # @param [String] directory
      #   Optional directory to search within for cached files.
      #
      # @yield [cached_file]
      #   The block that will receive all cached files.
      #
      # @yieldparam [Cacheable::CachedFile] cached_file
      #   The cached file.
      #
      def ObjectCache.each(directory=nil,&block)
        files = Cacheable::CachedFile.all
        
        if directory
          files = files.from(directory)
        end
          
        files.each(&block)
        return nil
      end

      #
      # Cache all objects loaded from the paths within the specified
      # _directory_.
      #
      # @param [String] directory
      #   The directory to cache all objects from.
      #
      def ObjectCache.cache(directory)
        ObjectCache.paths(directory).each do |path|
          catch_all { Cacheable::CachedFile.cache(path) }
        end

        return true
      end

      #
      # Syncs all objects that were previously cached from paths within
      # the specified _directory_. Also cache objects which have yet to
      # be cached from the _directory_.
      #
      # @param [String] directory
      #   The directory to sync all objects with.
      #
      # @return [true]
      #   Specifies that the syncing of the given directory was successful.
      #
      def ObjectCache.sync(directory)
        new_paths = ObjectCache.paths(directory)

        # Sync existing cached files
        ObjectCache.each(directory) do |cached_file|
          new_paths.delete(cached_file.path)

          catch_all { cached_file.sync }
        end

        # cache the remaining new paths
        new_paths.each do |path|
          catch_all { Cacheable::CachedFile.cache(path) }
        end

        return true
      end

      #
      # Deletes all cached objects that existed in the specified
      # _directory_.
      #
      # @param [String] directory
      #   Deletes all cached objects from the specified _directory_.
      #
      # @return [true]
      #   Specifies that the deletion of the objects, originally cached
      #   from the given directory, was successful.
      #
      def ObjectCache.clean(directory)
        ObjectCache.each(directory) do |cached_file|
          catch_all { cached_file.destroy }
        end

        return true
      end
    end
  end
end
