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
        # Initializes the cacheable object.
        #
        def initialize(*arguments,&block)
          @original_loaded = false
          @cache_prepared = false

          super(*arguments,&block)
        end

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
      end

      unless Cacheable.models.include?(base)
        Cacheable.models << base
      end
    end

    #
    # List of cacheable models.
    #
    def Cacheable.models
      @@ronin_cacheable_models ||= []
    end

    #
    # Loads all cacheable objects from the specified _path_. If a _block_
    # is given, it will be passed each loaded object.
    #
    def Cacheable.load_all_from(path,&block)
      path = File.expand_path(path)

      return Contextify.load_contexts(path).select do |obj|
        if obj.class.include?(Cacheable)
          obj.instance_variable_set('@original_loaded',true)
          obj.cached_path = path
          obj.cached_timestamp = File.mtime(path)
          obj.prepare_cache

          block.call(obj) if block
        end
      end
    end

    #
    # Cache all objects defined in the file at the specified _path_.
    #
    def Cacheable.cache_all(path)
      path = File.expand_path(path)

      Cacheable.load_all_from(path) do |obj|
        obj.cache!
      end
    end

    #
    # Load the code from the cached file for the object.
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
    # the database. Returns +true+ if the object was successfully cached,
    # returns +false+ otherwise.
    #
    def cache!
      if self.cached_path
        # delete any existing objects
        self.class.all(:cached_path => self.cached_path).destroy!

        self.cached_timestamp = File.mtime(self.cached_path)
        return save!
      end

      return false
    end

    #
    # Deletes any previous cached copies of the object and caches it into
    # the database, only if the file where the object was originally cached 
    # from was modified. The object will also be destroyed if the file
    # where the object was originally cached from is missing. Returns
    # +true+ if the object was successfully synced, returns +false+
    # otherwise.
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
    def cache(&block)
      @cache_block = block
    end

    #
    # Will load the context from the cached file and attempt to call the
    # method again.
    #
    def method_missing(name,*arguments,&block)
      unless @original_loaded
        load_original!
        return self.send(name,*arguments,&block)
      else
        return super(name,*arguments,&block)
      end
    end
  end
end
