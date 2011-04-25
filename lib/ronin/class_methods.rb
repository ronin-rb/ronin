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
  #
  # Class methods that are included when {Ronin} is included.
  #
  module ClassMethods
    #
    # Catches missing constants and searches the {Ronin} namespace.
    #
    # @param [Symbol] name
    #   The constant name.
    #
    # @return [Object]
    #   The found constant.
    #
    # @raise [NameError]
    #   The constant could not be found within {Ronin}.
    #
    # @since 1.0.0
    #
    # @api semipublic
    #
    def const_missing(name)
      Ronin.send(:const_missing,name) || super(name)
    end
  end
end
