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
require 'ronin/code/sql/between'

module Ronin
  module Code
    module SQL
      class Field < Expr

        def initialize(style,name,prefix=nil)
          super(style)

          @prefix = prefix
          @name = name
        end

        def *
          field_cache[:"*"]
        end

        def id
          field_cache[:id]
        end

        def between(start,stop)
          Between.new(self,start,stop)
        end

        def <=>(range)
          between(range.begin,range.end)
        end

        def compile
          if @prefix
            return "#{@prefix}.#{@name}"
          else
            return @name.to_s
          end
        end

        protected

        def method_missing(sym,*args)
          if (args.length==0 && @prefix.nil?)
            return field_cache[sym]
          end

          raise(NoMethodError,sym.id2name)
        end

        private

        def field_cache
          @field_cache ||= Hash.new { |hash,key| hash[key] = Field.new(@style,key,self) }
        end

      end
    end
  end
end
