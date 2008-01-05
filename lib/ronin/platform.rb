#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'og'

module Ronin
  class Platform

    # Name of the Operating System
    attr_accessor :os, String

    # Version of the Operating System
    attr_accessor :version, String

    #
    # Creates a new Platform object with the specified _os_ and the given
    # _version_. If _block_ is given, it will be passed the newly created
    # Platform object.
    #
    def initialize(os,version=nil,&block)
      @os = os
      @version = version

      block.call(self) if block
    end

    #
    # Returns true if the Platform has the same os and version as the
    # _other_ platform, returns false otherwise.
    #
    def ==(other)
      return false unless @os==other.os
      return @version==other.version
    end

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

    def Platform.namify(name)
      name.to_s.split.map { |word| word.capitalize }.join
    end

    #
    # Defines a new builtin Platform of the specified _name_, which will
    # define a new class named _name_ that inherites Platform.
    #
    #   Platform.define('FreeBSD')
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
      name = Platform.namify(name)

      Ronin.module_eval %{
        class #{name} < Platform

          def initialize(version=nil)
            super(#{name.dump},version)
          end

        end
      }
    end

    define 'FreeBSD'
    define 'Linux'
    define 'OpenBSD'
    define 'OSX'
    define 'NetBSD'
    define 'Windows'

  end
end
