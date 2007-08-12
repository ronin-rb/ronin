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

require 'product'
require 'vuln/classification'
require 'vuln/requirement'
require 'vuln/effect'

module Ronin
  module Advisories
    class Advisory

      # Group that published the advisory
      attr_reader :group

      # Name of the advisory
      attr_reader :name

      # Advisory title
      attr_reader :title

      # Advisory publish date
      attr_reader :published

      # Advisory update date
      attr_reader :updated

      # Vulnerability description
      attr_reader :description

      # Vulnerability classification
      attr_reader :classification

      # Vulnerability requirements
      attr_reader :requirements

      # Vulnerability effects
      attr_reader :effects

      # Vulnerable products
      attr_reader :products

      # Advised solution
      attr_reader :solution

      # Vulnerability discovery credits
      attr_reader :credits

      def initialize(group,name)
	@group = group
	@name = name

	@classification = []
	@requirements = []
	@effects = []

	@products = Hash.new do |hash,key|
	  hash[key] = Hash.new do |sub_hash,sub_key|
	    sub_hash[sub_key] = {}
	  end
	end

	@credits = []
      end

      def update
	# dummy place holder
      end

      def product(name,version,vendor)
	add_product(Product.new(name,version,vendor))
      end

      def add_product(product)
	@products[product.name][product.version][product.vendor] = product
      end

      def has_product?(name,version,vendor)
	return false unless @products.has_key?(name)
	return false unless @products[name].has_key?(version)
	return @products[name][version].has_key?(vendor)
      end

      def get_product(name,version,vendor)
	@products[name][version][vendor]
      end

      def to_s
        "#{group}-#{name}"
      end

    end
  end
end
