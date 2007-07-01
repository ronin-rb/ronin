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

require 'code/sql/primitives'

module Ronin
  module Code
    module SQL
      class Expr

	def initialize
	  @negated = false
	end

	def not!
	  @negated = true
	  return self
	end

	def is_null?
	  self.is?(null)
	end

	def not_null?
	  self.is_not?(null)
	end

	def in?(*range)
	  In.new(self,*range)
	end

	def ===(*range)
	  in?(*range)
	end

	def not_in?(*range)
	  in?(*range).not!
	end

	def compile
	  # place holder
	end

	def to_s
	  compile
	end

	protected

	include Primitives

	def negated?
	  return "NOT" if @negated
	end

	def Expr.binary_op(op,*ids)
	  for id in ids
	    class_eval <<-end_eval
	      def #{id}(expr)
	        BinaryExpr.new('#{op}',self,expr)
	      end
	    end_eval
	  end
	end

	binary_op 'OR', :or?
	binary_op 'AND', :and?
	binary_op 'XOR', :xor?
	binary_op '=', :==, :equals?
	binary_op '!=', :not_equals?
	binary_op 'IS', :is?
	binary_op 'IS NOT', :is_not?
	binary_op 'AS', :as
	binary_op 'CAST', :cast

	def Expr.like_op(op,*ids)
	  for id in ids
	    class_eval <<-end_eval
	      def #{id}(expr,escape=nil)
	        LikeExpr.new('#{op}',self,expr,escape)
	      end
	    end_eval
	  end
	end

	like_op 'LIKE', :like
	like_op 'GLOB', :glob
	like_op 'REGEXP', :regexp
	like_op 'MATCH', :match

	def Expr.unary_op(op,*ids)
	  for id in ids 
	    class_eval <<-end_eval
	      def #{id}
	        UnaryExpr.new('#{op}',self)
	      end
	    end_eval
	  end
	end

	unary_op 'NOT', :not
	unary_op 'EXISTS', :exists?

	def quote_string(data)
	  "'"+data.to_s.sub("'","''")+"'"
	end

	def compile_list(*expr)
	  expr.compact.join(', ')
	end

	def compile_datalist(*expr)
	  compile_group( expr.flatten.map { |value| compile_data(value) } )
	end

	def compile_group(*expr)
	  unless expr.length==1
	    return "(#{compile_list(expr)})"
	  else
	    return expr[0].to_s
	  end
	end

	def compile_data(data)
	  if data.kind_of?(Array)
	    return compile_datalist(data)
	  elsif data.kind_of?(String)
	    return quote_string(data)
	  else
	    return data.to_s
	  end
	end

	def compile_expr(*expr)
	  expr.compact.join(' ')
	end

      end
    end
  end
end
