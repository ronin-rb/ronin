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

require 'ronin/code/sql/builder'

module Ronin
  module Code
    module SQL
      class Program

        # Style of the program
        attr_reader :style

        def initialize(cmds=[],style=Style.new,&block)
          @style = style
          @builder = Builder.new(cmds,style,&block)
        end

        def dialect(name)
          @style.set_dialect(name)
        end

        def compile
          @builder.to_s
        end

        def to_s
          compile
        end

        def Program.compile(*cmds,&block)
          Program.new(cmds,&block).compile
        end

        protected

        def method_missing(sym,*args,&block)
          return @style.send(sym,*args,&block) if @style.respond_to?(sym)

          if @builder.respond_to?(sym)
            @builder.send(sym,*args,&block)
            return self
          end

          raise NoMethodError, sym.id2name, caller
        end

      end
    end
  end
end
