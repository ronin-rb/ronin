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

require 'exceptions/missingparam'

module Ronin
  class Param

    # Name of parameter
    attr_reader :name

    # Description of parameter
    attr_accessor :desc

    # Value of parameter
    attr_accessor :value

    def initialize(name,desc="",value=nil,&block)
      @name = name.to_s
      @desc = desc
      @value = value

      instance_eval(&block) if block
    end

    def to_s
      str = @name
      str+=" - #{@desc}" unless @desc.empty?
      str+=" [#{@value}]" if @value
      return str
    end

  end

  module Parameters
    def params
      @params ||= {}
    end

    def param(name,desc="",value=nil,&block)
      add_param(Param.new(name,desc,value,&block))
    end

    def add_param(parameter)
      if has_param?(parameter.name)
	# set param description if missing
	unless param_desc(name).length
	  params[name].desc = desc
	end

	# set param value if missing
	unless param_value(name)
	  params[name].value = value
	end
      else
        params[parameter.name] = parameter

	instance_eval <<-end_eval
	  def #{parameter.name}
	    get_param(:#{parameter.name}).value
	  end

	  def #{parameter.name}=(value)
	    get_param(:#{parameter.name}).value = value
	  end
	end_eval
      end
      return parameter
    end

    def has_param?(name)
      params.has_key?(name.to_s)
    end

    def get_param(name)
      return params[name.to_s]
    end

    def param_desc(name)
      return "" unless has_param?(name)
      return get_param(name).desc
    end

    def param_value(name)
      return nil unless has_param?(name)
      return get_param(name).value
    end

  end
end
