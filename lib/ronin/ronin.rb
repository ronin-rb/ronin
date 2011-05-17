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

require 'ronin/class_methods'
require 'ronin/auto_load'

module Ronin
  include AutoLoad

  #
  # Includes {ClassMethods} when {Ronin} is included.
  #
  # @param [Class, Module] base
  #   The class or module that {Ronin} is being included into.
  #
  # @since 1.0.0
  #
  # @api private
  #
  def self.included(base)
    base.send :extend, ClassMethods
  end
end
