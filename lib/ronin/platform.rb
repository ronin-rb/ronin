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

require 'og'

module Ronin
  class Platform

    # Name of the Operating System
    attr_reader :os, String

    # Version of the Operating System
    attr_reader :version, String

    def initialize(os,version=nil)
      @os = os
      @version = version
    end

    def ==(other)
      return false unless @os==other.os
      return @version==other.version
    end

    def to_s
      if @version
        return "#{@os} #{@version}"
      else
        return @os.to_s
      end
    end

    def Platform.define(name)
      name = Platform.platform_name(name)

      Ronin.module_eval %{
        class #{name} < Platform

          def initialize(version=nil)
            super(#{name.dump},version)
          end

        end
      }
    end

    protected

    def self.platform_name(name)
      name.to_s.split.map { |word| word.capitalize }.join
    end

    def Object.platform(name)
      Platform.define(name)
    end

    platform 'FreeBSD'
    platform 'Linux'
    platform 'OpenBSD'
    platform 'OSX'
    platform 'NetBSD'
    platform 'Windows'

  end
end
