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
  class Platform

    # Name of the Operating System
    attr_reader :os, String, :index => true

    # Version of the Operating System
    attr_reader :version, String, :index => true

    def initialize(os,version)
      @os = os.to_s
      @version = version.to_s

      Platform.platforms[@os][@version] = self
    end

    def ==(other)
      return false unless @os==other.os
      return @version==other.version
    end

    def Platform.platforms
      @@platforms ||= Hash.new do |hash,os|
        hash[os] = {}
      end
    end

    def Platform.all(&block)
      Platform.platforms.each_value do |os|
        os.each_value(&block)
      end
    end

  end
end
