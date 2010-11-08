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

require 'ronin/ui/command_line/command'
require 'ronin/database'

module Ronin
  module UI
    module CommandLine
      class ModelCommand < Command

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
        # @since 0.4.0
        #
        def self.model
          @model
        end

        #
        # The query options for the command.
        #
        # @return [Hash]
        #   The query options and their query method names.
        #
        # @since 0.4.0
        #
        def self.query_options
          @@query_options ||= {}
        end

        #
        # Default method performs the query and prints the found resources.
        #
        # @since 0.4.0
        #
        def execute
          Database.setup

          print_query(new_query)
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
        # @since 0.4.0
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
        # @option options [Symbol] :method (name)
        #   Custom query method name.
        #
        # @since 0.4.0
        #
        def self.query_option(name,options={},&block)
          self.query_options[name] = if block
                                       block
                                     elsif options[:method]
                                       options.delete(:method)
                                     else
                                       name
                                     end

          class_option(name,options)
        end

        #
        # Performs a custom query.
        #
        # @param [DataMapper::Collection] query
        #   The current query.
        #
        # @yield [query,*arguments]
        #   The given block will be passed the current query to modify.
        #
        # @yieldparam [DataMapper::Collection] query
        #   The current query.
        #
        # @yieldparam [Array] arguments
        #   Optional arguments that will be passed to the block.
        #
        # @return [DataMapper::Collection]
        #   The modified query.
        #
        # @since 0.4.0
        #
        def custom_query(query,arguments=[],&block)
          if block.arity == 1
            block.call(query)
          elsif block.arity == 2
            block.call(query,arguments)
          else
            block.call(query,*arguments)
          end
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
        # @since 0.4.0
        #
        def query_method(query,name,arguments=[])
          query_method = begin
                           query.model.instance_method(name)
                         rescue NameError
                           raise("Undefined query method #{query.model}.#{name}")
                         end

          case query_method.arity
          when 0
            query.send(name)
          when 1
            query.send(name,arguments)
          else
            query.send(name,*arguments)
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
        # @since 0.4.0
        #
        def new_query(&block)
          query = self.class.model.all

          self.class.query_options.each do |name,value|
            unless options[name].nil?
              query = if value.kind_of?(Proc)
                        custom_query(query,options[name],&value)
                      else
                        query_method(query,name,options[name])
                      end
            end
          end

          if block
            query = custom_query(query,&block)
          end

          return query
        end

        #
        # Default method which will print every queried resource.
        #
        # @param [DataMapper::Resource] resource
        #   A queried resource from the Database.
        #
        # @since 0.4.0
        #
        def print_resource(resource)
          puts resource
        end

        #
        # Prints the resources in the query.
        #
        # @param [DataMapper::Collection] query
        #   The query to print.
        #
        # @since 0.4.0
        #
        def print_query(query)
          if options.csv?
            print query.to_csv
          elsif options.xml?
            print query.to_xml
          elsif options.yaml?
            print query.to_yaml
          elsif options.json?
            print query.to_json
          else
            query.each { |resource| print_resource(resource) }
          end
        end

      end
    end
  end
end
