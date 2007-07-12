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
    def param(name)
      name = name.to_sym

      return instance_params[name] if instance_params.has_key?(name)
      return class_params[name] if class_params.has_key?(name)
    end

    def has_param?(name)
      name = name.to_sym

      return instance_params.has_key?(name) || class_params.has_key?(name)
    end

    def describe_param(name)
      name = name.to_sym

      return instance_param[name].description if instance_param.has_key?(name)
      return class_param[name].description if class_param.has_key?(name)

      raise ParamNotFound, "parameter '#{name}' does not exist", caller
    end

    def each_param(&block)
      instance_params.each_value(&block)
      class_params.each do |key,param|
	block.call(param) unless instance_params.has_key?(key)
      end
      return self
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

      Parameters.class_params[name] = Param.new(name,opts[:value],opts[:desc])
      class_eval <<-end_eval
        def self.#{name}
          Parameters.class_params[:#{name}].value
        end

        def #{name}
          unless instance_params.has_key?(:#{name})
            return Parameters.class_params[:#{name}].value.freeze
          else
            return instance_params[:#{name}].value
          end
        end

        def self.#{name}=(value)
          Parameters.class_params[:#{name}].value = value
        end

        def #{name}=(value)
          unless instance_params.has_key?(:#{name})
            adopt_param(Parameters.class_params[:#{name}])
          end

          return instance_params[:#{name}].value = value
        end
      end_eval
    end

    def parameter(name,opts={:value => nil, :desc => ""})
      name = name.to_sym

      instance_params[name] = Param.new(name,opts[:value],opts[:desc])
      instance_eval <<-end_eval
        def #{name}
          instance_params[:#{name}].value
        end

        def #{name}=(value)
          instance_params[:#{name}].value = value
        end
      end_eval
    end

    private

    def Parameters.class_params
      @@class_params ||= {}
    end

    def instance_params
      @instance_params ||= {}
    end

    def adopt_param(param)
      value = param.value.clone if param.value
      instance_params[param.name] = Param.new(param.name,value,param.description)
    end
  end
end
