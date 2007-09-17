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
  class License

    # License name
    attr_reader :name, String, :unqiue => true

    # Description of license
    attr_reader :description, String

    schema_inheritance

    def initialize(name,description=nil)
      @name = name.to_s
      @description = description

      License.licenses[@name] = self
    end

    def License.licenses
      @@licenses ||= {}
    end

    def License.exists?(name)
      License.licenses.has_key?(name.to_s)
    end

    def License.all(&block)
      License.licenses.each_value(&block)
    end

    def to_s
      @name.to_s
    end

    GPL2 = License.new('GPL-2','GNU Public License v2.0')
    GPL3 = License.new('GPL-3','GNU Public License v3.0')

  end
end
