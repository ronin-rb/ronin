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

require 'ronin/cacheable/cached_file'
require 'ronin/model'

require 'contextify'

module Ronin
  module Cacheable
    def self.included(base)
      base.module_eval do
        include Contextify
        include Ronin::Model

        belongs_to :cached_file,
                   :nullable => true,
                   :model => Ronin::Cacheable::CachedFile

        #
        # Loads an object from the file at the specified _path_.
        #
        def self.load_from(path)
          path = File.expand_path(path)
          obj = self.load_context(path)

          obj.instance_variable_set('@original_loaded',true)
          obj.cached_file = CachedFile.new(
            :path => path,
            :timestamp => File.mtime(path),
            :model_name => obj.class.to_s
          )
          obj.prepare_cache!
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
    # The file the object was cached from.
    #
    # @return [String]
    #   The path property from the +cached_file+ resource.
    #
    def cache_path
      if self.cached_file
        return File.expand_path(self.cached_file.path)
      end
    end

    #
    # The directory the object was cached from.
    #
    # @return [String]
    #   The directory for the path property from the +cached_file+ resource.
    #
    def cache_dir
      if (path = self.cache_path)
        return File.dirname(path)
      end
    end

    #
    # Determines if the original code, from the cache file, has been loaded
    # into the object.
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
      if (self.cached_file && !(@original_loaded))
        block = self.class.load_context_block(cache_path)

        instance_eval(&block) if block
        @original_loaded = true
      end

      return self
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
    def prepare_cache!
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
      if (self.cached_file && !(@original_loaded))
        load_original!

        return self.send(name,*arguments,&block)
      else
        return super(name,*arguments,&block)
      end
    end
  end
end
