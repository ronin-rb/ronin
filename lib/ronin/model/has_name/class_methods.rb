#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  module Model
    module HasName
      module ClassMethods
        #
        # Finds models with names containing a given fragment of text.
        #
        # @param [String] fragment
        #   The fragment of text to search for within the names of models.
        #
        # @return [Array<Model>]
        #   The found models.
        #
        # @example
        #   Exploit.named 'ProFTP'
        #
        def named(fragment)
          # we must use :name.like to avoid DataMapper confusing the name
          # property with the Class#name method
          all(:name.like => "%#{fragment}%")
        end
      end
    end
  end
end
