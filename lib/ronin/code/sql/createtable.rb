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

require 'ronin/code/sql/statement'
require 'ronin/code/sql/select'

module Ronin
  module Code
    module SQL
      class CreateTable < Statement

        option :temp, "TEMP"
        option :if_not_exists, "IF NOT EXISTS"

        def initialize(style,table=nil,opts={:columns => {}, :not_null => {}, :as => nil},&block)
          @table = table
          @columns = opts[:columns]
          @not_null = opts[:not_null]
          @as = opts[:as]

          super(style,&block)
        end

        def table(field)
          @table = field
          return self
        end

        def as(table=nil,opts={:fields => nil, :where => nil},&block)
          @as = Select.new(@style,table,opts,&block)
          return self
        end

        def column(name,type,null=false)
          name = name.to_s
          @columns[name] = type.to_s
          @not_null[name] = null
          return self
        end

        def primary_key(field)
          @primary_key = field
          return self
        end

        def compile
          format_columns = lambda {
            @columns.map { |name,type|
            if @not_null[name]
          "#{name} #{type} NOT NULL"
            else
          "#{name} #{type}"
            end
          }
          }

          return compile_expr(keyword_create,temp?,keyword_table,if_not_exists?,@table,compile_row(format_columns.call))
        end

        protected

        keyword :create
        keyword :table
        keyword :primary_key

        def primary_key?
          compile_expr(keyword_primary_key,@primary_key) if @primary_key
        end

      end
    end
  end
end
