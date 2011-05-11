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

require 'ronin/ui/cli/command'
require 'ronin/database'

require 'set'

module Ronin
  module UI
    module CLI
      #
      # A base-command for querying and exporting {Model}s.
      #
      class ModelCommand < Command

        class_option :database, :type => :string,
                                :aliases => '-D'

        class_option :csv, :type => :boolean
        class_option :xml, :type => :boolean
        class_option :yaml, :type => :boolean
        class_option :json, :type => :boolean

        #
        # The model to query.
        #
        # @return [DataMapper::Resource]
        #   The model that will be queried.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.model
          @model
        end

        #
        # The query options for the command.
        #
        # @return [Set]
        #   The query options and their query method names.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.query_options
          @query_options ||= Set[]
        end

        #
        # Default method performs the query and prints the found resources.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def execute
          print_resources(query)
        end

        protected

        #
        # Sets the model to query.
        #
        # @param [DataMapper::Resource] model
        #   The model class.
        #
        # @return [DataMapper::Resource]
        #   The model that will be queried.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.model=(model)
          @model = model
        end

        #
        # Defines a query option for the command.
        #
        # @param [Symbol] name
        #   The option name.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.query_option(name,options={})
          query_options << name
          class_option(name,options)
        end

        #
        # Sets up the {Database}.
        #
        # @since 1.1.0
        #
        # @api semipublic
        #
        def setup
          super

          if self.options[:database]
            Database.repositories[:default] = options[:database]
          end

          Database.setup
        end

        #
        # Invokes a query method on a query.
        #
        # @param [DataMapper::Collection] query
        #   The query.
        #
        # @param [Symbol] name
        #   The method name to call.
        #
        # @param [Array] arguments
        #   Additional arguments to pass to the query method.
        #
        # @return [DataMapper::Collection]
        #   The modified query.
        #
        # @raise [RuntimeError]
        #   The given name does not map to a query method or property,
        #   of the queried Model.
        #
        # @since 1.0.0
        #
        # @api private
        #
        def query_method(query,name,arguments=[])
          query_model = query.model

          if query_model.method_defined?(name)
            query_model.method(name).call(*arguments)
          elsif query_model.properties.named?(name)
            query_model.all(name => arguments)
          else
            raise("Unknown query method or property #{name} for #{query_model}")
          end
        end

        #
        # Builds a new query using the options of the command.
        #
        # @yield [query]
        #   If a block is given, it will be passed the new query.
        #
        # @yieldparam [DataMapper::Collection] query
        #   The new query.
        #
        # @return [DataMapper::Collection]
        #   The new query.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def query
          new_query = self.class.model.all

          self.class.ancestors.each do |ancestor|
            if ancestor < ModelCommand
              ancestor.query_options.each do |name|
                unless options[name].nil?
                  new_query = query_method(new_query,name,options[name])
                end
              end
            end
          end

          new_query = yield(new_query) if block_given?
          return new_query
        end

        #
        # Default method which will print every queried resource.
        #
        # @param [DataMapper::Resource] resource
        #   A queried resource from the Database.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def print_resource(resource)
          puts resource
        end

        #
        # Prints multiple resources.
        #
        # @param [DataMapper::Collection, Array<DataMapper::Resource>] resources
        #   The query to print.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def print_resources(resources)
          if options.csv?
            print resources.to_csv
          elsif options.xml?
            print resources.to_xml
          elsif options.yaml?
            print resources.to_yaml
          elsif options.json?
            print resources.to_json
          else
            resources.each { |resource| print_resource(resource) }
          end
        end

      end
    end
  end
end
