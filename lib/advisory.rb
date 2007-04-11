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

module Ronin
  class Advisory

    # Vulnerability classification.
    attr_accessor :classification

    # CVE
    attr_accessor :cve

    # Remote?
    attr_accessor :remote

    # Local?
    attr_accessor :local

    # Date published
    attr_accessor :published

    # Date updated
    attr_accessor :updated

    # Discovery credit
    attr_accessor :credits

    # Vulnerable products
    attr_reader :products

    # Product names
    attr_reader :product_names

    # Product versions
    attr_reader :product_versions

    # Product vendors
    attr_reader :product_vendors

    # Comments on the vulnerability.
    attr_accessor :comments

    def initialize(&block)
      @products = Hash.new do |hash,key|
	hash[key] = Hash.new do |sub_hash,sub_key|
	  sub_hash[sub_key] = {}
	end
      end

      hash_array = lambda {
	Hash.new { |hash,key| hash[key] = [] }
      }
      @product_names = hash_array.call
      @product_versions = hash_array.call
      @product_vendors = hash_array.call

      block.call(self) if block
    end

    def add_product(product)
      @products[product.name][product.version][product.vendor] = product

      @product_names[product.name] << product
      @product_versions[product.version] << product
      @product_vendors[product.vendor] << product
    end

    def has_product?(name,version,vendor)
      return false unless @products.has_key?(name)
      return false unless @products[name].has_key?(version)
      return @products[name][version].has_key?(vendor)
    end

    def product(name,version,vendor)
      @products[name][version][vendor]
    end

    def has_name?(name)
      @product_names.has_key?(name)
    end

    def has_version?(version)
      @product_versions.has_key?(version)
    end

    def has_vendor?(vendor)
      @product_vendors.has_key?(vendor)
    end

  end
end
