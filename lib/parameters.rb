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

module Ronin
  class Param

    # Name of parameter
    attr_reader :name

    # Description of parameter
    attr_reader :desc

    # Value associated with parameter
    attr_accessor :value

    def initialize(name,desc="",value=nil)
      @name = name
      @desc = desc
      @value = value
    end

  end

  module Parameters
    def params
      @params ||= {}
    end

    def params=(parameters)
      @params = parameters
    end

    def add_param(name,desc="",value=nil)
      params[name] = Param.new(name,desc,value)
    end

    def has_param?(name)
      params.has_key?(name)
    end

    def param(name)
      return params[name]
    end

    def param_desc(name)
      return param(name).desc if has_param?(name)
    end

    def param_value(name)
      return param(name).value if has_param?(name)
    end
  end
end
