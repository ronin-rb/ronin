#
#--
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
#++
#

require 'ronin/model'

require 'rexml/document'

module Ronin
  class Product

    include Model

    # Primary key
    property :id, Serial

    # Name
    property :name, String, :index => true

    # Version
    property :version, String, :index => true

    # Venders
    property :vendor, String

    # Validates
    validates_present :name, :version

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

    #
    # Returns the vendor name or the name of the product.
    #
    def vendor
      super || self.name
    end

  end
end
