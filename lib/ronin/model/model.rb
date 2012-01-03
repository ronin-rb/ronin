#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model/types'
require 'ronin/support/inflector'

require 'dm-core'
require 'dm-types'
require 'dm-migrations'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-serializer'

module Ronin
  #
  # Modifies a class so that it can represent a DataMapper model in the
  # {Database}.
  #
  module Model
    include Model::Types

    #
    # Sets up a class as a DataMapper model that can be used with the
    # {Database}. Also adds {ClassMethods} to the new model.
    #
    # @param [Class] base
    #   The class that will be setup as a DataMapper model.
    #
    def self.included(base)
      unless base < DataMapper::Resource
        base.send :include, DataMapper::Resource
      end

      base.send :include, DataMapper,
                          DataMapper::Migrations,
                          DataMapper::Serialize,
                          Model::Types,
                          InstanceMethods
      base.send :extend, ClassMethods
    end

    #
    # Class methods that are added when {Model} is included into a class.
    #
    module ClassMethods
      #
      # The default name to use when defining relationships with the
      # model.
      #
      # @return [Symbol]
      #   The name to use in relationships.
      #
      # @since 1.0.0
      #
      # @api semipublic
      #
      def relationship_name
        name = Support::Inflector.underscore(self.name.split('::').last)

        return Support::Inflector.pluralize(name).to_sym
      end

      #
      # Loads and initialize the resources.
      #
      # @api private
      #
      def load(records,query)
        resources = super(records,query)
        resources.each { |resource| resource.send :initialize }

        return resources
      end
    end

    #
    # Instance methods that are added when {Model} is included into a class.
    #
    module InstanceMethods
      #
      # Formats the attributes of the model into human readable names
      # and values.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Array<Symbol>] :exclude ([])
      #   A list of attribute names to exclude.
      #
      # @yield [name, value]
      #   If a block is given, it will be passed the name and humanized
      #   value of each attribute.
      #
      # @yieldparam [String] name
      #   The humanized name of the attribute.
      #
      # @yieldparam [String] value
      #   The human readable value of the attribute.
      #
      # @return [Hash{String => String}]
      #   A hash of the humanly readable names and values of the attributes.
      #
      # @api semipublic
      #
      def humanize_attributes(options={})
        exclude = [:id, :type]

        if options[:exclude]
          exclude += options[:exclude]
        end

        formatter = lambda { |value|
          if value.kind_of?(Array)
            value.map(&formatter).join(', ')
          elsif value.kind_of?(Symbol)
            Support::Inflector.humanize(value)
          else
            value.to_s
          end
        }

        formatted = {}

        self.attributes.each do |name,value|
          next if (value.nil? || (value.respond_to?(:empty?) && value.empty?))

          unless (exclude.include?(name) || value.nil?)
            name = name.to_s

            unless name[-3..-1] == '_id'
              name = Support::Inflector.humanize(name)
              value = formatter.call(value)

              if block_given?
                yield name, value
              end

              formatted[name] = value
            end
          end
        end

        return formatted
      end
    end
  end
end
