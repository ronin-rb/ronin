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

module Ronin
  module UI
    module CommandLine
      class EngineCommand < Command

        class_option :file, :type => :string, :aliases => '-f'

        #
        # Initializes the engine command.
        #
        # @param [Array] arguments
        #   Command-line arguments.
        #
        # @param [Array] opts
        #   Additional command-line options.
        #
        # @param [Hash] config
        #   Additional configuration.
        #
        # @see Command#initialize
        #
        def initialize(arguments=[],opts={},config={})
          super(arguments,opts,config)

          unless self.class.engine_class
            raise(StandardError,"#{self.class} does not have a defined engine_class")
          end

          @engine_class = self.class.engine_class
        end

        #
        # The class to load engines from.
        #
        # @return [Engine]
        #   The engine class.
        #
        # @since 0.4.0
        #
        def self.engine_class
          @engine_class
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

        protected

        #
        # Defines the class to load engines from.
        #
        # @param [Engine] model
        #   The engine class.
        #
        # @return [Engine]
        #   The new engine class.
        #
        # @since 0.4.0
        #
        def self.engine_class=(model)
          @engine_class = model
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
        def self.query_option(name,options={})
          self.query_options[name] = (options.delete(:method) || name)

          class_options(name,options)
        end

        query_option :name, :type => :string,
                            :aliases => '-n',
                            :method => :named

        query_option :describing, :type => :string, :aliases => '-d'

        query_option :version, :type => :string,
                               :aliases => '-V',
                               :method => :revision

        query_option :license, :type => :string,
                               :aliases => '-L',
                               :method => :licensed_under

        #
        # Loads an engine using the commands options.
        #
        # @return [Engine, nil]
        #   The newly loaded engine.
        #
        # @raise [RuntimeError]
        #   The engine class did not define the query method for one of the
        #   query options.
        #
        # @since 0.4.0
        #
        def load_engine
          if options[:file]
            return @engine_class.load_from(options[:file])
          end

          query = @engine_class.all

          self.class.query_options.each do |name|
            if options.has_key?(name)
              query_method = begin
                               @engine_class.instance_method(name)
                             rescue NameError
                               raise("Unknown query method #{@engine_class}.#{name}")
                             end

              query = case query_method.arity
                      when 0
                        query.send(name)
                      when 1
                        query.send(name,options[name])
                      else
                        query.send(name,*options[name])
                      end
            end
          end

          query.load_first
        end

      end
    end
  end
end
