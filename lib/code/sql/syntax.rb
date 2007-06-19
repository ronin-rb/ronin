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
      module Syntax
	def escape(*expr)
	  expr.map { |value| value.to_s.gsub("'","''") }
	end

	def quote(*expr)
	  expr.map { |value| "'#{value}'" }
	end

	def sql_and(*expr)
	  expr.join(" AND ")
	end

	def sql_or(*expr)
	  expr.join(" OR ")
	end

	def join(*expr)
	  expr.join("; ")
	end

	def like(field,search)
	  "#{field} LIKE '%#{search}%'"
	end

	def is(field,value)
	  "#{field} IS '#{value}'"
	end

	def all_rows(var='1')
	  "OR '#{var}'='#{var}'"
	end

	def comment
	  '--'
	end

	def has_table?(table)
	  "1=(SELECT COUNT(*) FROM #{table})"
	end

	def has_field?(field)
	  "#{field} IS NULL;"
	end

	def uses?(table,field)
	  "#{table}.#{field} IS NULL"
	end

	def where(expr)
	  "WHERE #{expr}"
	end

	def drop(table)
	  "DROP TABLE #{table}"
	end

	def select(table,opts={:fields => '*', :where => nil})
	  if opts[:fields].kind_of?(Array)
	    fields = "(#{opts[:fields].join(', ')})"
	  else
	    fields = opts[:fields].to_s
	  end

	  if opts[:where]
	    return "SELECT #{fields} FROM #{table} #{where(opts[:where])}"
	  else
	    return "SELECT #{fields} FROM #{table}"
	  end
	end

	def insert(table,data)
	  "INSERT INTO #{table} (#{quote(*(data.keys)).join(', ')}) VALUES (#{quote(*(data.values)).join(', ')})"
	end

	def update(table,data,where_expr=nil)
	  set_values = "SET "+data.map { |name,value|
	    "#{name} = #{quote(value)}"
	  }.join(', ')

	  if where_expr
	    return "UPDATE #{table} #{set_values} #{where(where_expr)}"
	  else
	    return "UPDATE #{table} #{set_values}"
	  end
	end

	def command(*cmds)
	  "; #{cmds.join('; ')}"
	end

	def sql_inject(expr="")
	  expr = expr.strip
	  if expr.rindex("'")==expr.length-1
	    return "' #{expr[0,expr.length-1]}"
	  else
	    unless expr.rindex(";")==expr.length-1
	      return "' #{expr}; #{comment}"
	    else
	      return "' #{expr} #{comment}"
	    end
	  end
	end
      end
    end
  end
end
