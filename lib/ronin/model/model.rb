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

require 'ronin/model/lazy_upgrade'

require 'extlib'
require 'dm-core'
require 'dm-types'
require 'dm-validations'
require 'dm-aggregates'

module Ronin
  #
  # Modifies a class so that it can represent a DataMapper model in the
  # {Database}.
  #
  module Model
    include DataMapper::Types

    def self.included(base)
      base.module_eval do
        unless self.ancestors.include?(DataMapper::Resource)
          include DataMapper::Resource
        end

        include DataMapper::Types
        include DataMapper::Migrations
        include Model::LazyUpgrade

        #
        # The default name to use when defining relationships with the
        # model.
        #
        # @return [Symbol]
        #   The name to use in relationships.
        #
        # @since 0.4.0
        #
        def self.relationship_name
          self.name.split('::').last.snake_case.plural.to_sym
        end

        def self.load(records,query)
          resources = super(records,query)

          # Forcibly call initialize after loading the resources
          resources.each { |resource| resource.send(:initialize) }

          return resources
        end
      end
    end

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
    def humanize_attributes(options={},&block)
      exclude = [:id, :type]

      if options[:exclude]
        exclude += options[:exclude]
      end

      formatter = lambda { |value|
        if value.kind_of?(Array)
          value.map(&formatter).join(', ')
        elsif value.kind_of?(Symbol)
          Extlib::Inflection.humanize(value)
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
            name = Extlib::Inflection.humanize(name)
            value = formatter.call(value)

            block.call(name,value) if block
            formatted[name] = value
          end
        end
      end

      return formatted
    end
  end
end
