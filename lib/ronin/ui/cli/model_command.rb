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

module Ronin
  module UI
    module CLI
      #
      # A base-command for querying {Model}s.
      #
      class ModelCommand < Command

        class_option :database, :type => :string,
                                :aliases => '-D'

        #
        # The model to query.
        #
        # @return [DataMapper::Resource]
        #   The model that will be queried.
        #
        # @since 1.1.0
        #
        # @api semipublic
        #
        def self.query_model
          @query_model ||= if self.superclass < ModelCommand
                       self.superclass.query_model
                     end
        end

        #
        # The query options for the command.
        #
        # @return [Array<Symbol>]
        #   The query options and their query method names.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.query_options
          @query_options ||= []
        end

        #
        # Iterates over the query options for the command.
        #
        # @yield [name]
        #   The given block will be passed the names of the query options.
        #
        # @yieldparam [Symbol] name
        #   The name of a query option.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator object will be returned.
        #
        # @since 1.1.0
        #
        def self.each_query_option(&block)
          return enum_for(:each_query_option) unless block

          self.class.ancestors.each do |ancestor|
            if ancestor < ModelCommand
              ancestor.query_options.each(&block)
            end
          end
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
        # @since 1.1.0
        #
        # @api semipublic
        #
        def self.model(model)
          @query_model = model
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
        # Builds a new query using the options of the command.
        #
        # @return [DataMapper::Collection]
        #   The new query.
        #
        # @raise [RuntimeError]
        #   The query option does not map to a query-method or property
        #   defined in the Model.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def query
          unless self.class.query_model
            raise("query model not defined for #{self.class}")
          end

          query = self.class.query_model.all

          self.class.each_query_option do |name|
            value = options[name]

            # skip unset options
            next if value.nil?

            if query_model.properties.named?(name)
              query = query.all(name => value)
            elsif query_model.respond_to?(name)
              query_method = query_model.method(name)

              query = case query_method.arity
                      when 0
                        query.send(name)
                      when 1
                        query.send(name,value)
                      else
                        query.send(name,*value)
                      end
            else
              raise("unknown query method or property #{name} for #{query_model}")
            end
          end

          return query
        end

      end
    end
  end
end
