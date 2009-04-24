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

module Ronin
  module UI
    module Verbose
      #
      # Enables verbose mode.
      #
      def Verbose.enable!
        @@ronin_verbose = true
      end

      #
      # Returns +true+ if verbose mode is enabled, returns +false+
      # otherwise.
      #
      def Verbose.enabled?
        (@@ronin_verbose ||= false) == true
      end

      #
      # Disables verbose mode.
      #
      def Verbose.disable!
        @@ronin_verbose = false
      end

      #
      # Returns +true+ if verbose mode is disabled, returns +false+
      # otherwise.
      #
      def Verbose.disabled?
        (@@ronin_verbose ||= false) == false
      end
    end
  end
end
