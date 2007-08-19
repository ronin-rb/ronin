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

require 'ronin/objectcache'

require 'rexml/document'

module Ronin
  class Product

    # Name
    attr_reader :name, String

    # Version
    attr_reader :version, String

    # Venders
    attr_reader :vendor, String

    def initialize(name,version,vendor)
      @name = name
      @version = version
      @vendor = vendor
    end

    def Product.parse(doc,xpath='/ronin/product')
      products = []

      doc.element.each(xpath) do |element|
        product_name = element.attribute('name').to_s
        element.each_element('version') { |version| product_version = version.get_text.to_s }
        element.each_element('vendor') { |vendor| product_vendor = vendor.get_text.to_s }

        products << Procut.new(product_name,product_version,product_vendor)
      end

      return products
    end

  end
end
