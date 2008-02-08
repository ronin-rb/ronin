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

require 'ronin/parameters/parameters'
require 'ronin/parameters/class_param'
require 'ronin/extensions/meta'

class Object

  protected

  #
  # Adds a new parameter with the specified _name_ and the given
  # _options_ to the class.
  #
  #   parameter 'var'
  #
  #   parameter 'var', :value => 3, :description => 'my variable'
  #
  def Object.parameter(name,options={})
    name = name.to_sym

    include Ronin::Parameters

    # add the parameter to the class params list
    params[name] = Ronin::ClassParam.new(name,options[:description],options[:value])

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

end
