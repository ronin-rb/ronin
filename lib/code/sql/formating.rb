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
      module Formating
	def escape_data(data)
	  data.to_s.sub("'","''")
	end

	def quote_data(data)
	  "'#{escape_data(data)}'"
	end

	def format_data(data)
	  if data.kind_of?(Command)
	    return "(#{data})"
	  elsif data.kind_of?(Array)
	    return data.flatten.map { |value| format_data(value) }.join(', ')
	  elsif data.kind_of?(Symbol)
	    return data.id2name
	  elsif data.kind_of?(String)
	    return quote_data(data)
	  else
	    return data.to_s
	  end
	end
      end
    end
  end
end
