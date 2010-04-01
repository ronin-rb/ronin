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

require 'ronin/platform/cached_file'
require 'ronin/model/model'

require 'contextify'

module Ronin
  module Platform
    #
    # The {Cacheable} module allows an instance of a {Model} to be cached
    # into the local {Database}, to be loaded later on. This is made
    # possible by creating a relationship between the model and the
    # {CachedFile} model.
    #
    # Once cached, {Cacheable} models can be quickly queried within the
    # {Database}, and a fresh copy of the object can be loaded from the
    # file it was originally cached from.
    #
    # # Making a Model cacheable
    #
    # In order to make a Model cacheable, one must include the {Cacheable}
    # module and contextifying the model. Contextifying a model involves
    # calling the `contextify` method, which defines a top-level method
    # used for loading model instances from files.
    #
    #     class MyModel
    #
    #         include Cacheable
    #
    #         # Defines the my_model method for loading instances from files
    #         contextify :my_model
    #
    #         # Primary key of the model
    #         property :id, Serial
    #
    #         # Title of the model
    #         property :title, String
    #
    #         # ...
    #
    #     end
    #
    # # Creating cacheable files
    #
    # Once a model is made {Cacheable}, it can load instances defined within
    # a file:
    #
    #     require 'ronin/my_model'
    #
    #     my_model do
    #
    #       cache do
    #         self.title = 'My model in a file'
    #       end
    #
    #       def some_method
    #         puts 'Even methods can be loaded from the file'
    #       end
    #
    #     end
    #
    # The above example shows a typical cacheable file for `MyModel`. The
    # file defines the ruby code to evaluate within a new instance of
    # `MyModel` within a `my_model` block. Since the contents of the
    # `my_model` block is simply evaluated within new instances, once can
    # set instance variables or define new methods.
    #
    # Any cacheable data is set within a `cache` block, so the cacheable
    # data is only set before caching.
    #
    # # Loading cacheable files
    #
    # Instances can be loaded from cacheable files using the `load_from`
    # class method of a cacheable Model.
    #
    #     my_model = MyModel.load_from('path/to/file.rb')
    #     # => #<MyModel:0x710e0428cde0 @id=nil @title="My model in a file'>
    #
    #     my_model.some_method
    #     # Even methods can be loaded from the file
    #     # => nil
    #
    module Cacheable
      def self.included(base)
        base.module_eval do
          include Contextify
          include Ronin::Model

          # The class-name of the cached object
          property :type, DataMapper::Types::Discriminator

          # The cached file of the object
          belongs_to :cached_file,
                     :required => false,
                     :model => 'Ronin::Platform::CachedFile'

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

            return obj
          end

          #
          # Loads all objects with the matching attributes.
          #
          # @param [Hash] attributes
          #   Attributes to search for.
          #
          def self.load_all(attributes={})
            self.all(attributes).each { |obj| obj.load_original! }
          end

          #
          # Loads the first object with matching attributes.
          #
          # @param [Hash] attributes
          #   Attributes to search for.
          #
          # @yield [objs]
          #   If a block is given, it will be passed all matching
          #   objects to be filtered down. The first object from the
          #   filtered objects will end up being selected.
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

        CachedFile.has 1, base.relationship_name,
                          :model => base.name
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
      # @return [Pathname]
      #   The path property from the `cached_file` resource.
      #
      def cache_path
        if self.cached_file
          return self.cached_file.path
        end
      end

      #
      # Determines if the original code, from the cache file, has been
      # loaded into the object.
      #
      # @return [Boolean]
      #   Specifies whether the original code has been loaded into the
      #   object.
      #
      def original_loaded?
        @original_loaded == true
      end

      #
      # Loads the code from the cached file for the object, and instance
      # evals it into the object.
      #
      # @return [Boolean]
      #   Indicates the original code was successfully loaded.
      #
      def load_original!
        if (cached? && !(original_loaded?))
          block = self.class.load_context_block(cache_path)

          @original_loaded = true
          instance_eval(&block) if block
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
      # Indicates whether the object has been cached.
      #
      # @return [Boolean]
      #   Specifies whether the object has been previously cached.
      #
      def cached?
        (saved? && self.cached_file)
      end

      protected

      #
      # Will call the given block only once, in order to prepare the
      # object for caching.
      #
      # @yield []
      #   The block will be ran inside the object when the object is to be
      #   prepared for caching.
      #
      # @return [Boolean]
      #   Specifies whether the object was successfully prepared for
      #   caching.
      #
      def cache(&block)
        unless (block.nil? || cached? || prepared_for_cache?)
          @cache_prepared = true

          block.call()
          return true
        end

        return false
      end

      #
      # Will load the context from the cached file and attempt to call the
      # method again.
      #
      def method_missing(name,*arguments,&block)
        if load_original!
          return self.send(name,*arguments,&block)
        else
          return super(name,*arguments,&block)
        end
      end
    end
  end
end
