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
          all(:name.like => "%#{fragment}%")
        end
      end
    end
  end
end
