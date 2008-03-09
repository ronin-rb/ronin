#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/parameters/class_param'
require 'ronin/parameters/instance_param'
require 'ronin/parameters/exceptions'
require 'ronin/extensions/meta'

module Ronin
  module Parameters
    def self.included(base) # :nodoc:
      base.metaclass_eval do
        #
        # Returns the +Hash+ of parameters for the class.
        #
        def params
          @params ||= {}
        end

        def parameter(name,options={})
          name = name.to_sym

          # add the parameter to the class params list
          params[name] = ClassParam.new(name,options[:description],options[:value])

          # define the reader class method for the parameter
          meta_def(name) do
            params[name].value
          end

          # define the writer class method for the parameter
          meta_def("#{name}=") do |value|
            params[name].value = value
          end

          # define the getter/setter instance methods for the parameter
          attr_accessor(name)
        end

        #
        # Returns the class parameter with the specified _name_. If no
        # such class parameter exists, a ParamNotFound exception will be
        # raised.
        #
        def get_param(name)
          name = name.to_sym

          ancestors.each do |superclass|
            if superclass.include?(Parameters)
              if superclass.params.has_key?(name)
                return superclass.params[name]
              end
            end
          end

          raise(ParamNotFound,"parameter #{name.to_s.dump} was not found in class #{self.name.dump}",caller)
        end

        #
        # Returns +true+ if a class parameters with the specified _name_
        # exists, returns +false+ otherwise.
        #
        def has_param?(name)
          name = name.to_sym

          ancestors.each do |superclass|
            if superclass.include?(Parameters)
              return true if superclass.params.has_key?(name)
            end
          end

          return false
        end

        #
        # Iterates over all class parameters, passing each one to the
        # specified _block_.
        #
        def each_param(&block)
          ancestors.each do |superclass|
            if superclass.include?(Parameters)
              superclass.params.each_value(&block)
            end
          end

          return self
        end

        #
        # Returns the description of the class parameters with the
        # specified _name_. If no such class parameter exists, a
        # ParamNotFound exception will be raised.
        #
        def describe_param(name)
          get_param(name).description
        end

        #
        # Returns the value of the class parameters with the specified
        # _name_. If no such class parameter exists, a ParamNotFound
        # exception will be raised.
        #
        def param_value(name)
          get_param(name).value
        end
      end
    end

    #
    # Calls initialize_parameters and then proceeds to call the
    # super-classes initialize.
    #
    def initialize(*args,&block)
      initialize_parameters()

      super(*args,&block)
    end

    #
    # Initializes all instance parameters based off the class parameter's
    # descriptions and default values.
    #
    def initialize_parameters
      # import the class parameters
      self.class.each_param { |param| initialize_param(param) }
    end

    #
    # Adds a new parameters with the specified _name_ and the given
    # _options_ to the object.
    #
    #   obj.parameter('var')
    #
    #   obj.parameter('var',:value => 3, :description => 'my variable')
    #
    def parameter(name,options={})
      name = name.to_sym

      # set the instance variable
      instance_variable_set("@#{name}",options[:value])

      # add the new parameter
      params[name] = InstanceParam.new(self,name,options[:description])

      # define the reader method for the parameter
      instance_eval %{
        def #{name}
          instance_variable_get("@#{name}")
        end
      }

      # define the writer method for the parameter
      instance_eval %{
        def #{name}=(value)
          instance_variable_set("@#{name}",value)
        end
      }

      return params[name]
    end

    #
    # Returns a Hash of the classes params.
    #
    def class_params
      self.class.params
    end

    #
    # Returns a +Hash+ of the instance parameters.
    #
    def params
      @params ||= {}
    end

    #
    # Returns +true+ if the a parameter with the specified _name_ exists,
    # returns +false+ otherwise.
    #
    #   obj.has_param?('rhost') # => true
    #
    def has_param?(name)
      params.has_key?(name.to_sym)
    end

    #
    # Returns the parameter with the specified _name_. If no such parameter
    # exists, a ParamNotFound exception will be raised.
    #
    #   obj.get_param('var') # => InstanceParam
    #
    def get_param(name)
      name = name.to_sym

      unless has_param?(name)
        raise(ParamNotFound,"parameter #{name.to_s.dump} was not found within #{self.to_s.dump}",caller)
      end

      return params[name]
    end

    #
    # Returns the description of the parameter with the specified _name_.
    # If no such parameter exists, a ParamNotFound exception will be raised.
    #
    #   obj.describe_param('rhost') # => "remote host"
    #
    def describe_param(name)
      get_param(name).description
    end

    #
    # Returns the value of the parameter with the specified _name_. If no
    # such parameter exists, a ParamNotFound exception will be raised.
    #
    #   obj.value_param('rhost') # => 80
    #
    def param_value(name)
      get_param(name).value
    end

    protected


    #
    # Initializes the specified class _param_.
    #
    def initialize_param(param)
      # set the instance variable if the param has a value
      if param.value
        # do not override existing instance value if present
        unless instance_variable_get("@#{param.name}")
          begin
            value = param.value.clone
          rescue TypeError
            value = param.value
          end

          instance_variable_set("@#{param.name}",value)
        end
      end

      params[param.name] = InstanceParam.new(self,param.name,param.description)
      return params[param.name]
    end
  end
end
