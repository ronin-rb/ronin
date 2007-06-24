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
  module Code
    module SQL
      module Fieldable

	protected

	def field_cache
	  @field_cache ||= {}
	end

	def get_field(name,prefix=nil)
	  name = name.to_s

	  return field_cache[name] if field_cache.has_key?(name)
	  return field_cache[name] = Field.new(name,prefix)
	end

	def method_missing(sym,*args)
	  name = sym.id2name
	  return get_field(name) if args.length==0

	  raise NoMethodError, name, caller
	end

      end
    end
  end
end
