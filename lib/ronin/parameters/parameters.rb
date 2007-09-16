#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'ronin/parameters/classparam'
require 'ronin/parameters/instanceparam'
require 'ronin/parameters/exceptions'
require 'ronin/extensions/meta'

module Ronin
  module Parameters
    def self.included(base)
      base.metaclass_eval do
        def params
          @params ||= {}
        end

        def param(name)
          name = name.to_sym

          ancestors.each do |superclass|
            if superclass.include?(Parameters)
              if superclass.params.has_key?(name)
                return superclass.params[name]
              end
            end
          end

          return nil
        end

        def has_param?(name)
          name = name.to_sym

          ancestors.each do |superclass|
            if superclass.include?(Parameters)
              return true if superclass.params.has_key?(name)
            end
          end

          return false
        end

        def each_param(&block)
          ancestors.each do |superclass|
            if superclass.include?(Parameters)
              superclass.params.each_value(&block)
            end
          end
        end

        def describe_param(name)
          param = param(name)

          unless param
            raise(ParamNotFound,"parameter '#{name}' was not found in class '#{self.name}'",caller)
          end

          return param.description
        end

        def param_value(name)
          param = param(name)

          unless param
            raise(ParamNotFound,"parameter '#{name}' was not found in class '#{self.name}'",caller)
          end

          return param.value
        end
      end
    end

    def initialize(*args,&block)
      initialize_parameters

      super(*args,&block)
    end

    def initialize_parameters
      # import the class parameters
      self.class.each_param { |param| initialize_param(param) }
    end

    def parameter(name,opts={:value => nil, :description => ""})
      name = name.to_sym

      # set the instance variable
      instance_variable_set("@#{name}",opts[:value])

      # add the new parameter
      params[name] = InstanceParam.new(self,name,opts[:description])

      # define the reader method for the parameter
      class_def(param.name) do
        instance_variable_get("@#{param.name}")
      end

      # define the writer method for the parameter
      class_def("#{param.name}=") do |value|
        instance_variable_set("@#{param.name}",value)
      end

      return params[name]
    end

    def class_params
      self.class.params
    end

    def params
      @params ||= {}
    end

    def param(name)
      params[name.to_sym]
    end

    def has_param?(name)
      params.has_key?(name.to_sym)
    end

    def describe_param(name)
      param = param(name)

      unless param
        raise(ParamNotFound,"parameter '#{name}' was not found",caller)
      end

      return param.description if param
    end

    def param_value(name)
      param = param(name)

      unless param
        raise(ParamNotFound,"parameter '#{name}' was not found",caller)
      end

      return param.value if param
    end

    protected

    def Object.parameter(name,opts={:value => nil, :description => ""})
      name = name.to_sym

      # add the parameter to the class params list
      params[name] = ClassParam.new(name,opts)

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
