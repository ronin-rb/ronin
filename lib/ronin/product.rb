#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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

require 'ronin/cacheable'

require 'rexml/document'

module Ronin
  class Product

    include Cacheable

    # Name
    property :name, :string

    # Version
    property :version, :string

    # Venders
    property :vendor, :string

    #
    # Returns the String form of the product.
    #
    def to_s
      unless @vendor==@name
        return "#{@vendor} #{@name} #{@version}"
      else
        return "#{@name} #{@version}"
      end
    end

    def self.from_xml(doc,xpath='/ronin/product')
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
