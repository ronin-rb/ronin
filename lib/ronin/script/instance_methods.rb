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

module Ronin
  module Script
    #
    # Instance methods for an {Script}.
    #
    # @since 1.1.0
    #
    module InstanceMethods
      #
      # Initializes the Ronin Script.
      #
      # @param [Array] arguments
      #   Arguments for initializing the Script.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def initialize(*arguments,&block)
        @source_loaded = false
        @cache_prepared = false

        if arguments.first.kind_of?(Hash)
          initialize_params(arguments.first)
        end

        super(*arguments,&block)
      end

      #
      # The script type.
      #
      # @return [String]
      #   The name of the script class.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def script_type
        @script_type ||= self.class.base_model.name.split('::').last
      end

      #
      # Determines if the original code, from the cache file, has been
      # loaded into the object.
      #
      # @return [Boolean]
      #   Specifies whether the original code has been loaded into the
      #   object.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def source_loaded?
        @source_loaded == true
      end

      #
      # Loads the code from the cached file for the object, and instance
      # evaluates it into the object.
      #
      # @return [Boolean]
      #   Indicates the original code was successfully loaded.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def load_script!
        if (cached? && !source_loaded?)
          block = self.class.load_object_block(self.script_path.path)

          @source_loaded = true
          instance_eval(&block) if block
          return true
        end

        return false
      end

      #
      # @return [Boolean]
      #   Specifies whether the object has been prepared to be cached,
      #
      # @since 1.1.0
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
      # @since 1.1.0
      #
      # @api private
      #
      def cached?
        (saved? && self.script_path)
      end

      #
      # Default method which invokes the script.
      #
      # @param [Array] arguments
      #   Optional arguments.
      #
      # @since 1.1.0
      #
      def run(*arguments)
      end

      #
      # Converts the script to a String.
      #
      # @return [String]
      #   The name and version of the script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def to_s
        if (self.name && self.version)
          "#{self.name} #{self.version}"
        elsif self.name
          super
        elsif self.version
          self.version.to_s
        end
      end

      #
      # Inspects both the properties and parameters of the Ronin Script.
      #
      # @return [String]
      #   The inspected Ronin Script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def inspect
        body = []

        self.attributes.each do |name,value|
          body << "#{name}: #{value.inspect}"
        end

        param_pairs = []

        self.params.each do |name,param|
          param_pairs << "#{name}: #{param.value.inspect}"
        end

        body << "params: {#{param_pairs.join(', ')}}"

        return "#<#{self.class}: #{body.join(', ')}>"
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
      # @since 1.1.0
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
    end
  end
end
