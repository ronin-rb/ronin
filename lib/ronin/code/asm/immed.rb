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

require 'ronin/code/asm/type'

module Ronin
  module Asm

    #
    # The Immed class is used to represent the following types of memory
    # accesses:
    #
    #   (mem)
    #   disp(mem)
    #   (mem,index,scale) = (mem + index * scale)
    #   (mem,index) = (mem,index,1)
    #   (mem,,scale) = (mem,1,scale)
    #

    class Immed < Type

      # Base
      attr_reader :base

      # Index
      attr_reader :index

      # Scale
      attr_reader :scale

      def initialize(base,index=0,scale=1)
        @base = base
        @index = index
        @scale = scale
      end

      def +(disp)
        Immed.new(self,disp)
      end

      def is_resolved?
        return false if resolved?(@base)
        return false if resolved?(@index)
        return false if resolved?(@scale)
        return true
      end

      def resolve(block)
        unless is_resolved?
          return Immed.new(block.resolve_sym(@base),block.resolve_sym(@index),block.resolve_sym(@scale))
        end

        return self
      end

      def to_s
        if index==1
          return "(#{@base},1,#{@scale})"
        elsif index!=0
          if scale==1
            return "(#{@base},#{@index})"
          else
            return "(#{@base},#{@index},#{@scale})"
          end
        else
          return "(#{@base})"
        end
      end

    end
  end
end
