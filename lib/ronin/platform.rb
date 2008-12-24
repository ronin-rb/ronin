#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/model'
require 'ronin/extensions/meta'
require 'ronin/extensions/string'

module Ronin
  class Platform

    include Model

    # Primary key
    property :id, Serial

    # Name of the Operating System
    property :os, String, :index => true

    # Version of the Operating System
    property :version, String, :index => true

    # Validates
    validates_present :os, :version

    #
    # Returns the String form of the Platform.
    #
    #   platform = Platform.new("Linux","2.6.11")
    #   platform.to_s # => "Linux 2.6.11"
    #
    def to_s
      if @version
        return "#{@os} #{@version}"
      else
        return @os.to_s
      end
    end

    #
    # Defines a new builtin Platform of the specified _name_, which will
    # define a new class named _name_ that inherites Platform.
    #
    #   Platform.define('FreeBSD')
    #
    # Whould define the following class:
    #
    #   class FreeBSD < Platform
    #
    #     def initialize(version=nil)
    #       super("FreeBSD",version)
    #     end
    #
    #   end
    #
    def Platform.define(name)
      name = name.to_s
      method_name = name.to_method_name

      meta_def(method_name) do
        Platform.new(:os => name)
      end

      meta_def("#{method_name}_version") do |version|
        Platform.first_or_create(:os => name, :version => version.to_s)
      end

      return nil
    end

    define 'Linux'
    define 'FreeBSD'
    define 'OpenBSD'
    define 'NetBSD'
    define 'OSX'
    define 'Solaris'
    define 'Windows'
    define 'UNIX'

  end
end
