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

require 'ronin/model/cacheable/class_methods'
require 'ronin/model/model'
require 'ronin/cached_file'

require 'object_loader'
require 'set'

module Ronin
  module Model
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
    # In order to make a Model cacheable, one must include the {Cacheable}.
    #
    #     class MyModel
    #
    #         include Ronin::Model::Cacheable
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
      @models = Set[]

      def self.included(base)
        base.send :include, ObjectLoader, Model
        base.send :extend, ClassMethods

        base.module_eval do
          # The class-name of the cached object
          property :type, DataMapper::Property::Discriminator

          # The cached file of the object
          belongs_to :cached_file,
                     :required => false,
                     :model => 'Ronin::CachedFile'
        end

        CachedFile.has 1, base.relationship_name,
                          :model => base.name

        @models << base
      end

      #
      # The models that are cacheable.
      #
      # @return [Set<Cacheable>]
      #   Cacheable models.
      #
      # @since 1.0.0
      #
      # @api private
      #
      def Cacheable.models
        @models
      end

      #
      # Loads the first cacheable object from a file.
      #
      # @param [String] path
      #   The file to load the cacheable object from.
      #
      # @return [Cacheable]
      #   The cacheable object.
      #
      # @raise [RuntimeError]
      #   There were no cacheable objects defined in the file.
      #
      # @since 1.0.0
      #
      # @api private
      #
      def Cacheable.load_from(path)
        path = File.expand_path(path)
        obj = ObjectLoader.load_objects(path).find do |obj|
          obj.class < Cacheable
        end

        unless obj
          raise(RuntimeError,"No cacheable object defined in #{path.dump}")
        end

        obj.instance_variable_set('@original_loaded',true)
        obj.cached_file = CachedFile.new(
          :path => path,
          :timestamp => File.mtime(path),
          :model_name => obj.class.to_s
        )

        return obj
      end

      #
      # Initializes the cacheable object.
      #
      # @api semipublic
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
      # @api private
      #
      def cache_path
        self.cached_file.path if self.cached_file
      end

      #
      # Determines if the original code, from the cache file, has been
      # loaded into the object.
      #
      # @return [Boolean]
      #   Specifies whether the original code has been loaded into the
      #   object.
      #
      # @api private
      #
      def original_loaded?
        @original_loaded == true
      end

      #
      # Loads the code from the cached file for the object, and instance
      # evaluates it into the object.
      #
      # @return [Boolean]
      #   Indicates the original code was successfully loaded.
      #
      # @api private
      #
      def load_original!
        if (cached? && !(original_loaded?))
          block = self.class.load_object_block(self.cache_path)

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
      # @api private
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
      # @api private
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
      # @api public
      #
      def cache
        if (block_given? && !(cached? || prepared_for_cache?))
          @cache_prepared = true

          yield
          return true
        end

        return false
      end

      #
      # Will load the object from the cached file and attempt to call the
      # method again.
      #
      # @api semipublic
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
