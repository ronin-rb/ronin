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

require 'ronin/cacheable'

module Ronin
  module Platform
    module ObjectCache
      #
      # Returns all paths within the specified _directory_ pointing
      # to object files.
      #
      def ObjectCache.paths(directory)
        Dir[File.join(File.expand_path(directory),'**','*.rb')]
      end

      #
      # Finds all cached objects, passing each to the given _block_.
      #
      def ObjectCache.each(directory=nil,&block)
        attributes = {}

        if directory
          attributes.merge!(:cached_path.like => File.join(directory,'%'))
        end

        Cacheable.models.each do |base|
          base.all(attributes).each(&block)
        end

        return true
      end

      #
      # Cache all objects loaded from the paths within the specified
      # _directory_.
      #
      def ObjectCache.cache(directory)
        ObjectCache.paths(directory).each do |path|
          Cacheable.cache(path)
        end

        return true
      end

      #
      # Syncs all objects that were previously cached from paths within
      # the specified _directory_. Also cache objects which have yet to
      # be cached.
      #
      def ObjectCache.sync(directory)
        new_paths = ObjectCache.paths(directory)

        ObjectCache.each(directory) do |obj|
          new_paths.delete(obj.cached_path)

          obj.sync!
        end

        # cache the remaining new paths
        new_paths.each { |path| Cacheable.cache(path) }
        return true
      end

      #
      # Deletes all cached objects that existed in the specified
      # _directory_.
      #
      def ObjectCache.clean(directory)
        ObjectCache.each(directory) { |obj| obj.destroy }
        return true
      end
    end
  end
end
