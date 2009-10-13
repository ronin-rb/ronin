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

require 'ronin/model'

require 'contextify'

module Ronin
  module Cacheable
    def self.included(base)
      base.module_eval do
        include Contextify
        include Ronin::Model

        # The path to the file where the object was defined in
        property :cached_path, DataMapper::Types::FilePath

        # The timestamp of the cached file
        property :cached_timestamp, DataMapper::Types::EpochTime

        #
        # Loads an object from the file at the specified _path_.
        #
        def self.load_from(path)
          path = File.expand_path(path)
          obj = self.load_context(path)

          obj.instance_variable_set('@original_loaded',true)
          obj.cached_path = path
          obj.cached_timestamp = File.mtime(path)
          obj.prepare_cache
          return obj
        end

        #
        # Caches an object from the file at the specified _path_.
        #
        def self.cache(path)
          obj = self.load_from(File.expand_path(path))

          obj.cache!
          return obj
        end

        #
        # Loads all objects with the matching _attributes_.
        #
        def self.load_all(attributes={})
          self.all(attributes).map { |obj| obj.load_original! }
        end

        #
        # Loads the first object with matching attributes.
        #
        # @param [Hash] attributes
        #   Attributes to search for.
        #
        # @yield [objs]
        #   If a block is given, it will be passed all matching
        #   objects to be filtered down. The first object from the filtered
        #   objects will end up being selected.
        #
        # @yieldparam [Array<Cacheable>] objs
        #   All matching objects.
        #
        # @return [Cacheable]
        #   The loaded cached objects.
        #
        def self.load_first(attributes={},&block)
          obj = if block
                  objs = self.all(attributes)

                  (block.call(objs) || objs).first
                else
                  self.first(attributes)
                end

          obj.load_original! if obj
          return obj
        end
      end

      base.after_class_method(:all) do |*args|
        if (objs = args.first)
          objs.each do |obj|
            obj.instance_variable_set('@cache_prepared',true)
          end
        end
      end

      base.after_class_method(:first) do |*args|
        if (obj = args.first)
          obj.instance_variable_set('@cache_prepared',true)
        end
      end

      unless Cacheable.models.include?(base)
        Cacheable.models << base
      end
    end

    #
    # @return [Array]
    #   List of cacheable models.
    #
    def Cacheable.models
      @@ronin_cacheable_models ||= []
    end

    #
    # Loads all cacheable objects from the specified _path_.
    #
    # @param [String] path
    #   The path to load the objects from.
    #
    # @yield [obj]
    #   If a block is given, it will be passed each loaded object.
    #
    # @yieldparam [Cacheable] obj
    #   An object loaded from the specified _path_.
    #
    # @return [Array]
    #   All objects loaded from the specified _path_.
    #
    def Cacheable.load_all_from(path,&block)
      path = File.expand_path(path)
      objs = Contextify.load_contexts(path).select do |obj|
        obj.class.include?(Cacheable)
      end
      
      objs.each do |obj|
        obj.instance_variable_set('@original_loaded',true)
        obj.cached_path = path
        obj.cached_timestamp = File.mtime(path)
        obj.prepare_cache

        block.call(obj) if block
      end

      return objs
    end

    #
    # Cache all objects defined in a file.
    #
    # @param [String] path
    #   The path to cache all objects from.
    #
    def Cacheable.cache_all(path)
      path = File.expand_path(path)

      Cacheable.load_all_from(path) do |obj|
        obj.cache!
      end
    end

    #
    # Initializes the cacheable object.
    #
    def initialize(*arguments,&block)
      @original_loaded = false
      @cache_prepared = false

      super(*arguments,&block)
    end

    #
    # The directory the object was cached from.
    #
    # @return [String]
    #   The base-directory of the objects +cached_path+ property.
    #
    def cache_dir
      if self.cached_path
        return File.dirname(self.cached_path)
      end
    end

    #
    # @return [Boolean]
    #   Specifies whether the original code has been loaded into the
    #   object.
    #
    def original_loaded?
      @original_loaded == true
    end

    #
    # Loads the code from the cached file for the object, and instance evals
    # it into the object.
    #
    def load_original!
      if (self.cached_path && !(@original_loaded))
        block = self.class.load_context_block(self.cached_path)

        instance_eval(&block) if block
        @original_loaded = true
      end

      return self
    end

    #
    # Deletes any previously cached copies of the object and caches it into
    # the database.
    #
    # @return [Boolean]
    #   Specifies whether the object was successfully cached,
    #
    def cache!
      if self.cached_path
        # explicitly call lazy_upgrade!
        self.class.lazy_upgrade!

        # delete any existing objects
        self.class.all(:cached_path => self.cached_path).destroy!

        self.cached_timestamp = File.mtime(self.cached_path)
        return save
      end

      return false
    end

    #
    # Deletes any previous cached copies of the object and caches it into
    # the database, only if the file where the object was originally cached 
    # from was modified. The object will also be destroyed if the file
    # where the object was originally cached from is missing.
    #
    # @return [Boolean]
    #   Specifies whether the object was successfully synced.
    #
    def sync!
      if (self.cached_path && self.cached_timestamp)
        if File.file?(self.cached_path)
          if File.mtime(self.cached_path) > self.cached_timestamp
            self.class.cache(self.cached_path)
          else
            return false
          end
        else
          self.destroy
        end

        return true
      end

      return false
    end

    #
    # @return [Boolean]
    #   Specifies whether the object has been prepared to be cached,
    #
    def prepared_for_cache?
      @cache_prepared == true
    end

    #
    # Prepares the object for caching.
    #
    def prepare_cache
      unless @cache_prepared
        instance_eval(&(@cache_block)) if @cache_block
        @cache_prepared = true
      end
    end

    protected

    #
    # Will run the specified _block_ when the object is about to be cached.
    #
    # @yield []
    #   The block will be ran inside the object when the object is to be
    #   prepared for caching.
    #
    def cache(&block)
      @cache_block = block
    end

    #
    # Will load the context from the cached file and attempt to call the
    # method again.
    #
    def method_missing(name,*arguments,&block)
      if (self.cached_path && !(@original_loaded))
        load_original!

        return self.send(name,*arguments,&block)
      else
        return super(name,*arguments,&block)
      end
    end
  end
end
