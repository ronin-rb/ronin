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

require 'ronin/code/asm/compiliable'
require 'ronin/code/asm/deref'

module Ronin
  module Code
    module ASM
      class Register

        include Compiliable

        # The register index
        attr_reader :name

        def initialize(style,name)
          @style = style
          @name = name.to_sym
        end

        #
        # reg + disp = disp(reg)
        #
        def +(disp)
          Deref.new(self,disp)
        end

        #
        # reg * scale = (reg,,scale)
        #
        def *(scale)
          Deref.new(self,1,scale)
        end

        #
        # reg[index] = (reg,index)
        # reg[index,scale] = (reg,index,scale)
        #
        def [](index,scale=1)
          Deref.new(self,index,scale)
        end

        def compile
          if syntax==:att
            return "%#{@name}"
          elsif syntax==:intel
            return @name.to_s
          end
        end

      end
    end
  end
end
