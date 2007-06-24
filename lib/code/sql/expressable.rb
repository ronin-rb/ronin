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
      module Expressable

	def not!
	  @negate = true
	  return self
	end

	protected

	def negated?
	  return "NOT" if @negate
	end

	def self.binary_op(op,*ids)
	  for id in ids
	    class_eval <<-end_eval
	      def #{id}(expr)
	        BinaryExpr.new('#{op}',self,expr)
	      end
	    end_eval
	  end
	end

	binary_op 'AND', :and
	
	binary_op '=', :==, :equals?
	binary_op '!=', :not_equals?
	binary_op 'IS', :is?
	binary_op 'IN', :===, :in
	binary_op 'NOT IN', :not_in
	binary_op 'AS', :as
	binary_op 'CAST', :cast

	def self.like_op(op,*ids)
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

	def self.unary_op(op,*ids)
	  for id in ids 
	    class_eval <<-end_eval
	      def #{id}
	        UnaryExpr.new('#{op}',self)
	      end
	    end_eval
	  end
	end

	unary_op 'NOT', :not
	unary_op 'ISNULL', :is_null?
	unary_op 'NOTNULL', :not_null
	unary_op 'EXISTS', :exists?

	def format_expr(*expr)
	  expr.compact.join(' ')
	end

      end
    end
  end
end
