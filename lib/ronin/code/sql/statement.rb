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

require 'ronin/code/sql/expr'
require 'ronin/code/sql/field'
require 'ronin/code/sql/binaryexpr'
require 'ronin/code/sql/unaryexpr'
require 'ronin/code/sql/likeexpr'
require 'ronin/code/sql/in'
require 'ronin/code/sql/function'

module Ronin
  module Code
    module SQL
      class Statement < Expr

        def initialize(style,&block)
          super(style)

          instance_eval(&block) if block
        end

        protected

        def Statement.option(id,value=nil)
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
          keyword('#{value}') if @#{id}
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

    def Statement.option_list(id,values=[])
      values.each do |opt|
        class_eval <<-end_eval
        def #{opt}(&block)
          @#{id} = '#{opt.to_s.upcase}'

          if block
            instance_eval(&block)
            return self
          end
        end
      end_eval
      end

      class_eval <<-end_eval
      def #{id}?
      keyword(@#{id}) if @#{id}
    end
    end_eval
  end

  def all_fields
    field_cache[:"*"]
  end

  def id
    field_cache[:id]
  end

  def or!(*expr)
    if expr.length==2
      return BinaryExpr.new(@style,'OR',expr[0],expr[1])
    else
      return BinaryExpr.new(@style,'OR',expr.shift,or!(*expr))
    end
  end

  def and!(*expr)
    if expr.length==2
      return BinaryExpr.new(@style,'AND',expr[0],expr[1])
    else
      return BinaryExpr.new(@style,'AND',expr.shift,and!(*expr))
    end
  end

  def xor!(*expr)
    if expr.length==2
      return BinaryExpr.new(@style,'XOR',expr[0],expr[1])
    else
      return BinaryExpr.new(@style,'XOR',expr.shift,xor!(*expr))
    end
  end

  def method_missing(sym,*args)
    return @style.express(sym,*args) if @style.expresses?(sym)

    unless args.empty?
      # Return a function if there are arguments
      return Function.new(@style,sym,*args)
    else
      # Otherwise return a field
      return field_cache[sym]
    end

    raise(NoMethodError,sym.id2name)
  end

  private

  def field_cache
    @field_cache ||= Hash.new { |hash,key| hash[key] = Field.new(@style,key) }
  end

end
    end
  end
end
