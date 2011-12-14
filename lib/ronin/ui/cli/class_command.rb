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

require 'parameters'

module Ronin
  module UI
    module CLI
      #
      # @since 1.4.0
      #
      class ClassCommand < Command

        protected

        # The object created from the Class
        attr_reader :object

        #
        # Sets or gets the class namespace.
        #
        # @param [Module, nil] new_namespace
        #   The namespace to load the class from.
        #
        # @return [Module]
        #   The namespace that the class resides in.
        #
        # @api semipublic
        #
        def self.class_namespace(new_namespace=nil)
          if new_namespace
            @class_namespace = new_namespace
          else
            @class_namespace ||= if superclass < ClassCommand
                                   superclass.class_namespace
                                 end
          end
        end

        #
        # Sets or gets the class name.
        #
        # @param [Symbol, nil] name
        #   The class name to load from the namespace.
        #
        # @return [Symbol]
        #   The class name.
        #
        # @api semipublic
        #
        def self.class_name(name=nil)
          if name
            @class_name = name.to_sym
          else
            @class_name ||= self.name.split('::').last.to_sym
          end
        end

        #
        # The loaded class from the namespace.
        #
        # @return [Class]
        #   The loaded class.
        #
        # @api semipublic
        #
        def self.command_class
          @command_class ||= class_namespace.const_get(class_name)
        end

        # Mapping of parameter type Classes to Command option types
        PARAM_TYPES = {
          TrueClass  => :boolean,
          FalseClass => :boolean,

          Integer => :numeric,
          Fixnum  => :numeric,
          Float   => :numeric,

          String => :string,

          Array => :array,
          Hash  => :hash
        }

        #
        # Defines an option that maps to a parameter in the Class.
        #
        # @param [Symbol] name
        #   The name of the option.
        #
        # @param [Hash] options
        #   Additional options for the option.
        #
        # @api semipublic
        #
        def self.param_option(name,options={})
          unless command_class < Parameters
            raise(TypeError,"#{command_class} does not include Parameters")
          end

          param   = command_class.get_param(name)
          options = options.dup

          options[:type]    ||= PARAM_TYPES[param.type || param.value.class]
          options[:default] ||= param.value
          options[:desc]    ||= param.description

          class_option(name,options)
        end

        #
        # Sets up the Class command.
        #
        # @param [Array] arguments
        #   Additional arguments for the Class.
        #
        # @api semipublic
        #
        def setup(*arguments)
          super()

          @object = self.class.command_class.new(*arguments)

          # populate parameters with command options
          @object.params = options

          # populate additional parameters that map to arguments
          self.class.arguments.each do |argument|
            if @object.has_param?(argument.name)
              @object.set_param(argument.name,send(argument.name))
            end
          end
        end

      end
    end
  end
end
