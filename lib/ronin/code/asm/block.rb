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
require 'ronin/code/asm/style'
require 'ronin/code/asm/comment'
require 'ronin/code/asm/register'
require 'ronin/code/asm/instruction'

module Ronin
  module Code
    module ASM
      class Block

        include Compiliable

        # Elements
        attr_accessor :elements

        def initialize(style,&block)
          @style = style
          @elements = []

          extend(@style.dialect)

          inline(&block)
        end

        def inline(&block)
          instance_eval(&block)
        end

        def compile
          @elements.map { |elem| elem.to_s }
        end

        def ==(block)
          @elements==block.elements
        end

        def +(obj)
          new_block = self.clone

          if obj.kind_of?(Block)
            new_block.elements += obj.elements
          else
            new_block.elements << obj
          end

          return new_block
        end

        def <<(obj)
          if obj.kind_of?(Array)
            obj.each { |element| self << element }
          else
            @elements << obj
          end

          return self
        end

      end
    end
  end
end
