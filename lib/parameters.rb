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
      klass.metaclass.class_eval do
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
	      superclass.params.each { |param| block.call(param) }
	    end
	  end
	end
      end
    end

    def parameter(name,opts={:value => nil, :desc => ""})
      name = name.to_sym

      # add the parameter to the instance parameters
      params[name] = Param.new(name,opts[:value],opts[:desc])

      # define the reader method for the parameter
      class_def(name) do
        params[name.to_sym].value
      end

      # define the writer method for the parameter
      class_def("#{name}=") do |value|
	params[name.to_sym].value = value
      end
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
      param(name).description
    end

    def adopt_param(param)
      value = param.value.clone if param.value
      params[param.name] = Param.new(param.name,value,param.description)
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
      params[name] = Param.new(name,opts[:value],opts[:desc])

      # define the reader class method for the parameter
      meta_def(name) {
	params[name].value
      }

      # define the writer class method for the parameter
      meta_def("#{name}=") { |value|
	params[name].value = value
      }

      # define the reader instance method for the parameter
      class_def(name) {
	unless params.has_key?(name)
	  return class_params[name].value.freeze
	else
	  return params[name].value
	end
      }

      # define the writer instance method for the parameter
      class_def("#{name}=") { |value|
	unless params.has_key?(name)
	  adopt_param(class_params[name])
	end

	return params[name].value = value
      }
    end
  end
end
