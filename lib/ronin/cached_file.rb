#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/support/inflector'
require 'ronin/model'
require 'ronin/script'

require 'object_loader'

module Ronin
  autoload :Repository, 'ronin/repository'

  #
  # The {CachedFile} model stores information in the {Database} about
  # cached files containing {Script} objects.
  #
  # @api private
  #
  class CachedFile

    include Model

    # The primary key of the cached file
    property :id, Serial

    # The path to the file where the object was defined in
    property :path, FilePath, :required => true

    # The timestamp of the cached file
    property :timestamp, Time, :required => true

    # The class name of the cached object
    property :model_name, String, :required => true

    # The repository the file was cached from
    belongs_to :repository

    # Any exceptions raise when loading a fresh object
    attr_reader :cache_exception

    # Any cache errors encountered when caching the object
    attr_reader :cache_errors

    #
    # The path to require to access the Class of the cached object.
    #
    # @return [String]
    #   The possible path inferred from the class name.
    #
    def model_path
      if self.model_name
        Support::Inflector.underscore(self.model_name)
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
                DataMapper::Ext::Object.full_const_get(self.model_name)
              rescue NameError
                return nil
              end

      # filter out non-script classes
      return model if model < Script
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
    # A freshly loaded {Script} object from the cache file.
    #
    # @return [Script, nil]
    #   The first {Script} object loaded from the cache file.
    #   If `nil` is returned, the file did not contain any cacheable
    #   objects or the cache file contained a syntax error.
    #   
    def fresh_object
      begin
        # load the first found object
        blocks = ObjectLoader.load_blocks(self.path)
      rescue Exception => e
        @cache_exception = e
        return nil
      end

      blocks.each do |model,block|
        if model < Script
          # create the fresh object
          object = model.new()

          begin
            object.instance_eval(&block)

            @cache_exception = nil
            return object
          rescue Exception => e
            @cache_exception = e
          end
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
        return self.path.mtime > self.timestamp
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
      !(self.path.file?)
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
        # reset the model-class
        self.model_name = obj.class.to_s

        # update the timestamp
        self.timestamp = self.path.mtime

        # re-cache the fresh_object
        obj.cached_file = self

        if obj.save
          @cache_errors = nil
          return true
        else
          @cache_errors = obj.errors
        end
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
          obj.destroy!
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
    def destroy
      unless destroyed?
        if (obj = self.cached_object)
          obj.destroy!
        end
      end

      super
    end

  end
end
