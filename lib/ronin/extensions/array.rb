#
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
#

class Array

  #
  # Returns the power set of the array. Shamelessly borrowed from
  # http://johncarrino.net/blog/2006/08/11/powerset-in-ruby/.
  #
  # @example
  #   [1,2,3].power_set
  #   # => [[], [3], [2], [2, 3], [1], [1, 3], [1, 2], [1, 2, 3]]
  #
  def power_set
    inject([[]]) do |power_set,element|
      sub_set = []

      power_set.each do |i|
        sub_set << i
        sub_set << i + [element]
      end

      sub_set
    end
  end

end
