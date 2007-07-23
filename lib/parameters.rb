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

require 'exceptions/paramnotfound'
require 'extensions/meta'

module Ronin
  class Param

    # Name of parameter
    attr_reader :name

    # Description of parameter
    attr_accessor :description

    # Value of parameter
    attr_accessor :value

    def initialize(name,value=nil,description="")
      @name = name.to_sym
      @description = description
      @value = value
    end

    def to_s
      str = @name
      str+=" - #{@description}" unless @description.empty?

      if @value.kind_of?(Hash)
	str+="\n"+@value.to_a.map { |pair| "#{pair[0]} = #{pair[1]}" }.join("\t\n")
      elsif @value.kind_of?(Array)
	str+='['+@values.join(', ')+']'
      elsif @value
	str+=" [#{@value}]"
      end
      return str
    end

  end

  module Parameters
    def self.included(klass)
      # do not re-parameterize classes
      return unless klass.include?(self)

      # parameterize the class
      parameterize(klass)

      # define base-methods for the sub-class parameter methods to recurse to
      klass.class_eval %{
        def self.has_class_param?(name)
	  #{klass}.class_params.has_key?(name.to_sym)
        end

        def has_class_param?(name)
          #{klass}.has_class_param?(name)
        end

	def self.has_param?(name)
	  has_class_param?(name)
	end

	def instance_params
	  @instance_params ||= {}
	end

	def has_instance_param?(name)
	  instance_params.has_key?(name.to_sym)
	end

	def self.param(name)
	  name = name.to_sym

	  return #{klass}.class_params[name] if #{klass}.has_class_param?(name)

	  raise ParamNotFound, "parameter '#\{name\}' does not exist", caller
	end

        def param(name)
	  name = name.to_sym

	  return instance_params[name] if has_instance_param?(name)
	  return #{klass}.class_params[name] if #{klass}.has_class_param?(name)

	  raise ParamNotFound, "parameter '#\{name\}' does not exist", caller
	end

	def has_param?(name)
	  name = name.to_sym

	  return true if has_instance_param?(name)
	  return true if #{klass}.has_class_param?(name)
	  return false
	end

        def each_param(&block)
          instance_params.each_value(&block)
          class_params.each do |key,param|
	    block.call(param) unless has_instance_param?(key)
          end

          return self
        end
      }

      # have sub-classes automatically inherit the parameters
      klass.class_eval {
	def self.inherited(subclass)
	  Parameters.inherit_parameters(subclass)
	end
      }
    end

    def parameter(name,opts={:value => nil, :desc => ""})
      name = name.to_sym

      # add the parameter to the instance parameters
      instance_params[name] = Param.new(name,opts[:value],opts[:desc])

      # define the reader method for the parameter
      class_def(name) do
        instance_params[name.to_sym].value
      end

      # define the writer method for the parameter
      class_def("#{name}=") do |value|
	instance_params[name.to_sym].value = value
      end
    end

    def describe_param(name)
      param(name).description
    end

    def import_params(params)
      params.each do |param|
	adopt_param(param) if has_param?(param.name)
      end
    end

    def adopt_params(obj)
      obj.each_param do |param|
	adopt_param(param) if has_param?(param.name)
      end
      return self
    end

    protected

    def Object.parameter(name,opts={:value => nil, :desc => ""})
      name = name.to_sym

      # add the parameter to the class params list
      class_params[name] = Param.new(name,opts[:value],opts[:desc])

      # define the reader class method for the parameter
      meta_def(name) {
	class_params[name].value
      }

      # define the writer class method for the parameter
      meta_def("#{name}=") { |value|
	class_params[name].value = value
      }

      # define the reader instance method for the parameter
      class_def(name) {
	unless instance_params.has_key?(name)
	  return class_params[name].value.freeze
	else
	  return instance_params[name].value
	end
      }

      # define the writer instance method for the parameter
      class_def("#{name}=") { |value|
	unless instance_params.has_key?(name)
	  adopt_param(class_params[name])
	end

	return instance_params[name].value = value
      }
    end

    def self.parameterize(klass)
      # define the class parameters in the class
      klass.meta_eval {
	def class_params
	  @class_params ||= {}
	end
      }

      klass.class_eval {
	def self.class_params
	  metaclass.class_params
	end
      }
    end

    def self.inherit_parameters(klass)
      parameterize(klass)

      klass.class_eval %{
        def self.has_class_param?(name)
          name = name.to_sym

          return true if #{klass}.class_params.has_key?(name)
          return super(name)
        end

        def self.param(name)
          name = name.to_sym

	  return #{klass}.class_params[name] if #{klass}.class_params.has_key?(name)
          return super(name)

	  raise ParamNotFound, "parameter '#\{name\}' does not exist", caller
        end

        def param(name)
	  name = name.to_sym

	  return instance_params[name] if has_instance_param?(name)
	  return #{klass}.class_params[name] if #{klass}.class_params.has_key?(name)
	  return super(name)
	end

	def has_param?(name)
	  name = name.to_sym

	  return true if instance_params.has_key?(name)
	  return true if #{klass}.class_params.has_key?(name)
	  return super(name)
	end

        def each_param(&block)
          instance_params.each_value(&block)
          class_params.each do |key,param|
	    block.call(param) unless instance_params.has_key?(key)
          end

          super(&block)
          return self
        end
      }
    end

    private

    def adopt_param(param)
      value = param.value.clone if param.value
      instance_params[param.name] = Param.new(param.name,value,param.description)
    end
  end
end
