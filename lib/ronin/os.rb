#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/model'
require 'ronin/model/has_name'
require 'ronin/os_guess'
require 'ronin/ip_address'
require 'ronin/extensions/meta'

module Ronin
  #
  # Represents an Operating System and pre-defines other common ones
  # ({linux}, {freebsd}, {openbsd}, {netbsd}, {osx}, {solaris}, {windows}
  # and {unix}).
  #
  class OS

    include Model
    include Model::HasName

    # Primary key
    property :id, Serial

    # Version of the Operating System
    property :version, String, :index => true

    # Any OS guesses for the Operating System
    has 0..n, :os_guesses, :model => 'OSGuess'

    # Any IP Addresses that might be running the Operating System
    has 0..n, :ip_addresses, :through => :os_guesses,
                             :model => 'IPAddress',
                             :via => :ip_address

    #
    # The IP Address that was most recently guessed to be using the
    # Operating System.
    #
    # @return [IPAddress]
    #   The IP Address most recently guessed to be using the
    #   Operating System.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def recent_ip_address
      relation = self.os_guesses.first(:order => [:created_at.desc])

      if relation
        return relation.ip_address
      end
    end

    #
    # Converts the Operating System to a String.
    #
    # @return [String]
    #   The OS name and version.
    #
    # @example
    #   os = OS.new(:name => 'Linux', :version => '2.6.11')
    #   os.to_s # => "Linux 2.6.11"
    #
    # @api public
    #
    def to_s
      if self.version
        "#{self.name} #{self.version}"
      else
        super
      end
    end

    #
    # Splits the Operating System into multiple variables.
    #
    # @return [Array<String>]
    #   The name and version of the Operating System.
    #
    # @example
    #   os = OS.linux('2.6.31')
    #   name, version = os
    #
    #   name
    #   # => "Linux"
    #   version
    #   # => "2.6.31"
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_ary
      [self.name, self.version]
    end

    #
    # Defines a new predefined OS.
    #
    # @param [Symbol, String] name
    #   The method name to define for the predefined OS.
    #
    # @param [String] os_name
    #   The name of the OS.
    #
    # @return [nil]
    #
    # @example
    #   OS.predefine :freebsd, 'FreeBSD'
    #
    # @api private
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
