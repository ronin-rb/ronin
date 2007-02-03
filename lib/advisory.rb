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

require 'productlist'

module Ronin
  class Advisory

    # Vulnerability classification.
    attr_reader :class

    # CVE
    attr_reader :cve

    # Remote?
    attr_reader :remote

    # Local?
    attr_reader :local

    # Date published
    attr_reader :published

    # Date updated
    attr_reader :updated

    # Discovery credit
    attr_reader :credits

    # Vulnerable products
    attr_reader :products

    # Comments on the vulnerability.
    attr_reader :comments

    def initialize
      @products = ProductList.new
    end

  end
end
