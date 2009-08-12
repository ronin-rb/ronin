#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'extlib'

module Ronin
  class OS

    include Model

    # Primary key
    property :id, Serial

    # Name of the Operating System
    property :name, String, :index => true

    # Version of the Operating System
    property :version, String, :index => true

    # Validates
    validates_present :name

    #
    # Returns the String form of the os.
    #
    #   os = OS.new(:name => 'Linux', :version => '2.6.11')
    #   os.to_s # => "Linux 2.6.11"
    #
    def to_s
      if self.version
        return "#{self.name} #{self.version}"
      else
        return self.name.to_s
      end
    end

    #
    # Defines a new builtin OS of the specified _name_ and _os_name_.
    #
    #   OS.predefine :freebsd, 'FreeBSD'
    #
    def OS.predefine(name,os_name)
      os_name = os_name.to_s

      meta_def(name) do |*arguments|
        if (version = arguments.first)
          OS.first_or_create(:name => os_name, :version => version.to_s)
        else
          OS.new(:name => os_name)
        end
      end

      return nil
    end

    # The Linux OS
    predefine :linux, 'Linux'

    # The FreeBSD OS
    predefine :freebsd, 'FreeBSD'

    # The OpenBSD OS
    predefine :openbsd, 'OpenBSD'

    # The NetBSD OS
    predefine :netbsd, 'NetBSD'

    # OSX
    predefine :osx, 'OSX'

    # The Solaris OS
    predefine :solaris, 'Solaris'

    # The Windows OS
    predefine :windows, 'Windows'

    # The family UNIX OSes
    predefine :unix, 'UNIX'

  end
end
