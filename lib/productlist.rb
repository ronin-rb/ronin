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

module Ronin
  class Product

    # Name
    attr_reader :name

    # Version
    attr_reader :version

    # Venders
    attr_reader :vendor

    def initialize(name,version,vendor)
      @name = name
      @version = version
      @vendor = vendor
    end

  end

  class ProductSupport

    # Name
    attr_reader :name

    # Version
    attr_reader :version

    # Venders
    attr_reader :vendors

    def initialize(name,version,vendors=[])
      @name = name
      @version = version
      @vendors = vendors
    end

    def supported?(product)
      return false if @name!=product.name
      return false if @version!=product.version
      return false if (@venders & [product.vendor]).empty?
      return true
    end

  end

  class ProductList < Array

    def contains?(product)
      self.each do |support|
	break true if support.supported(product)
      end
    end

  end
end
