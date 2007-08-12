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

require 'objectcache'
require 'arch'

module Ronin
  class Platform

    # Name of the Operating System
    attr_reader :os, String

    # Version of the Operating System
    attr_reader :version, String

    # Architecture of the Platform
    has_one :arch

    def initialize(os,version,arch)
      @os = os
      @version = version
      @arch = arch

      Platform.platforms[os][version][arch.arch] = self
    end

    def Platform.platforms
      @@platforms ||= Hash.new do |hash,platform|
	hash[platform.os] = Hash.new do |hash,platform|
	  hash[platform.version] = {}
	end
      end
    end

    def Platform.all(&block)
      Platform.platforms.each_value do |os|
	os.each_value do |version|
	  version.each_value { |arch| block.call(arch) }
	end
      end
    end

  end

  class Linux < Platform

    def initialize(version,arch)
      super('Linux',version,arch)
    end

  end

  class FreeBSD < Platform

    def initialize(version,arch)
      super('FreeBSD',version,arch)
    end

  end

  class OpenBSD < Platform

    def initialize(version,arch)
      super('OpenBSD',version,arch)
    end

  end

  class NetBSD < Platform

    def initialize(version,arch)
      super('NetBSD',version,arch)
    end

  end

  class Windows < Platform

    def initialize(version,arch)
      super('Windows',version,arch)
    end

  end

  class OSX < Platform

    def initialize(version,arch)
      super('OSX',version,arch)
    end

  end
end
