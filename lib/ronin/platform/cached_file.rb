#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model'

require 'extlib'
require 'contextify'

module Ronin
  module Platform
    #
    # The {CachedFile} model stores information in the {Database} about
    # files that {Cacheable} Models were cached from. {CachedFile} also
    # manages the {Cacheable} objects that were saved in the {Database}.
    #
    class CachedFile

      include Ronin::Model

      # The primary key of the cached file
      property :id, Serial

      # The path to the file where the object was defined in
      property :path, DataMapper::Types::FilePath

      # The timestamp of the cached file
      property :timestamp, DataMapper::Types::EpochTime

      # The class name of the cached object
      property :model_name, String

      # The overlay the file was cached from
      belongs_to :overlay

      #
      # Finds all cached files that were cached from a given directory.
      #
      # @param [String] directory
      #   The directory search for.
      #
      # @return [DataMapper::Collection<CachedFile>]
      #   The cached files that were cached from the given directory.
      #
      def CachedFile.from(directory)
        all(:path.like => File.join(File.expand_path(directory),'%'))
      end

      #
      # Creates a new CacheFile object with a given path, and caches it.
      #
      # @return [CacheFile, nil]
      #   The saved CacheFile. Returns `nil` if no objects could be cached
      #   from the file.
      #
      def CachedFile.cache(path)
        file = CachedFile.new(:path => File.expand_path(path))

        unless file.cache
          return nil
        end

        return file
      end

      #
      # The path to require to access the Class of the cached object.
      #
      # @return [String]
      #   The possible path infered from the class name.
      #
      def model_path
        if self.model_name
          return self.model_name.to_const_path
        end
      end

      #
      # The Model of the cached object.
      #
      # @return [Class, nil]
      #   Returns the Model of the cached object, or `nil` if the class
      #   could not be loaded or found.
      #
      def cached_model
        return unless self.model_name

        # filter out unloadable models
        begin
          require model_path
        rescue Gem::LoadError => e
          raise(e)
        rescue ::LoadError
        end

        # filter out missing class names
        model = begin
                  ::Object.full_const_get(self.model_name)
                rescue NameError
                  return nil
                end

        # filter out non-Cacheable models
        if model.ancestors.include?(Cacheable)
          # lazy upgrade the model before usage
          model.lazy_upgrade!

          return model
        end
      end

      #
      # The object from the Database that was cached from the file.
      #
      # @return [Model]
      #   The previously cached object connected to the cache file.
      #
      def cached_object
        if (model = self.cached_model)
          return model.first(:cached_file => self)
        end
      end

      #
      # A freshly loaded Cacheable object from the cache file.
      #
      # @return [Cacheable, nil]
      #   The first Cacheable object loaded from the cache file.
      #   Returns `nil` if the file did not contain any cacheable objects.
      #   
      def fresh_object
        # load the first found context
        Contextify.load_blocks(self.path).each do |name,block|
          model = Contextify.contexts[name]

          if model.ancestors.include?(Cacheable)
            # lazy upgrade the model before creating the object
            model.lazy_upgrade!

            # create the fresh object
            object = model.new()
            object.instance_eval(&block)
            return object
          end
        end

        return nil
      end

      #
      # Determines if the cache file was updated.
      #
      # @return [Boolean]
      #   Specifies whether the cache file was updated.
      #
      def updated?
        # assume updates if there is no timestamp
        return true unless self.timestamp

        if File.file?(self.path)
          return File.mtime(self.path).to_i > self.timestamp.to_i
        end

        # do not assume updates, if there is no path
        return false
      end

      #
      # Determines if the cache file was deleted.
      #
      # @return [Boolean]
      #   Specifies whether the cache file was deleted.
      #
      def missing?
        !(File.file?(self.path))
      end

      #
      # Caches the freshly loaded object from the cache file into the
      # Database.
      #
      # @return [Boolean]
      #   Specifies whether the object was successfully cached.
      #
      def cache
        if (obj = fresh_object)
          # re-cache the fresh_object
          obj.cached_file = self
          obj.save

          # reset the model-class
          self.model_name = obj.class.to_s

          # update the timestamp
          self.timestamp = File.mtime(self.path)

          return save
        end

        return false
      end

      #
      # Syncs the cached object in the Database with the object loaded from
      # the cache file.
      #
      # @return [Boolean]
      #   Specifies whether the cached object was successfully synced.
      #
      def sync
        if missing?
          # destroy the cached file, if the actual file is missing
          return destroy
        elsif updated?
          if (obj = cached_object)
            # destroy the previously cached object
            obj.destroy
          end

          unless cache
            # if we couldn't cache anything, self-destruct
            destroy
          end

          return true
        end

        return false
      end

      #
      # Before destroying the cached file object, also destroy the
      # associated cached object.
      #
      def destroy!
        unless destroyed?
          if (obj = self.cached_object)
            obj.destroy
          end
        end

        super
      end

    end
  end
end
