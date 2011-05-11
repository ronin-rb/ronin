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
        # @return [Hash{Symbol => Method,DataMapper::Property}]
        #   The query options and their query method names.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.query_options
          @query_options ||= {}
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
        # @raise [RuntimeError]
        #   The query option does not map to a query-method or property
        #   defined in the Model.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.query_option(name,options={})
          if model.properties.named?(name)
            query_options[name] = model.properties[name]
          else
            begin
              query_options[name] = model.method(name)
            rescue NameError
              raise("Unknown query method or property #{name} for #{model}")
            end
          end

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
          query = self.class.model.all

          self.class.ancestors.each do |ancestor|
            if ancestor < ModelCommand
              ancestor.query_options.each do |name,query_method|
                value = options[name]

                unless value.nil?
                  case query_method
                  when Method
                    query = case query_method.arity
                            when 0
                              query.send(name)
                            when 1
                              query.send(name,value)
                            else
                              query.send(name,*value)
                            end
                  when DataMapper::Property
                    query = query.all(name => value)
                  end
                end
              end
            end
          end

          return query
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
