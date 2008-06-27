#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'pathname'

module Ronin
  class Path < Pathname

    #
    # Creates a new Path object with _n_ number of <tt>..</tt> directories.
    #
    #   Path.up(7)
    #   # => #<Ronin::Path:../../../../../../..>
    #
    def self.up(n)
      self.new(File.join(['..'] * n))
    end

    #
    # Joins the _args_ with the path, but does not resolve the resulting
    # path.
    #
    #   Path.up(7).join('etc/passwd')
    #   # => #<Ronin::Path:../../../../../../../etc/passwd>
    #
    def join(*args)
      self.class.new(File.join(self,*names))
    end

    #
    # Joins _name_ with the path, but does not resolve the resulting path.
    #
    #   Path.up(7) / 'etc' / 'passwd'
    #   # => #<Ronin::Path:../../../../../../../etc/passwd>
    #
    def /(name)
      join(name)
    end

  end
end
