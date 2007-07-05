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

require 'code/sql/statement'
require 'code/sql/select'

module Ronin
  module Code
    module SQL
      class CreateView < Statement

	option :temp, "TEMP"
	option :if_not_exists, "IF NOT EXISTS"

	def initialize(style,view=nil,query=nil,&block)
	  @view = view
	  @query = query

	  super(style,&block)
	end

	def view(field)
	  @view = field
	  return self
	end

	def query(table=nil,opts={:fields => nil, :where => nil},&block)
	  @query = Select.new(@style,table,opts,&block)
	  return self
	end

	def compile
	  compile_expr(keyword_create,temp?,keyword_view,if_not_exists?,@view,keyword_as,@query)
	end

	protected

	keyword :create
	keyword :view
	keyword :as

      end
    end
  end
end
