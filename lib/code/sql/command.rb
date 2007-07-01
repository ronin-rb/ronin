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

require 'code/sql/expr'
require 'code/sql/style'
require 'code/sql/primitives'
require 'code/sql/fieldcache'
require 'code/sql/binaryexpr'
require 'code/sql/unaryexpr'
require 'code/sql/likeexpr'
require 'code/sql/in'
require 'code/sql/aggregate'

module Ronin
  module Code
    module SQL
      class Statement < Expr

	include Primitives
	include FieldCache

	def initialize(style,&block)
	  super()

	  @style = style
	  instance_eval(&block) if block
	end

	def dialect(name)
	  @style.set_dialect(name)
	end

	def multiline(value)
	  @style.multiline = value
	end

	def multiline?
	  @style.multiline
	end

	def lowercase(value)
	  @style.lowercase = value
	end

	def lowercase?(value)
	  @style.lowercase = value
	end

	def and?(*expr)
	  if expr.length==1
	    return expr[0]
	  else
	    return expr.shift.and?(and?(*expr))
	  end
	end

	def or?(*expr)
	  if expr.length==1
	    return expr[0]
	  else
	    return expr.shift.or?(or?(*expr))
	  end
	end

	protected

	def Command.option(id,value=nil)
	  class_eval <<-end_eval
	    def #{id}(&block)
	      @#{id} = true

	      instance_eval(&block) if block
	      return self
	    end
	  end_eval

	  if value
	    class_eval <<-end_eval
	      protected

	      def #{id}?
	        "#{value}" if @#{id}
	      end
	    end_eval
	  else
	    class_eval <<-end_eval
	      protected

	      def #{id}?
	        @#{id}
	      end
	    end_eval
	  end
	end

	def Object.option_list(id,values=[])
	  values.each do |opt|
	    class_eval <<-end_eval
	      def #{opt}(&block)
	        @#{id} = "#{opt.to_s.capitalize}"

	        instance_eval(&block) if block
	        return self
	      end
	    end_eval
	  end

	  class_eval <<-end_eval
	    def #{id}?
	      @#{id}
	    end
	  end_eval
	end

	def method_missing(sym,*args)
	  return @style.express(sym,*args) if @style.expresses?(sym)
	  return super(sym,*args)
	end

      end
    end
  end
end
