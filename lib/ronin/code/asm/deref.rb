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
    module ASM
      #
      # The Deref class is used to represent the following types of memory
      # accesses:
      #
      #   (base) -> Deref.new(base)
      #   disp(base) -> Deref.new(base,disp)
      #   (base,index,scale) -> Deref.new(base,index,scale)
      #   (base,index) -> Deref.new(base,index,1)
      #   (base,,scale) -> Deref.new(base,1,scale)
      #
      class Deref

        include Compiliable

        # Base
        attr_reader :base

        # Index
        attr_reader :index

        # Scale
        attr_reader :scale

        def initialize(style,base,index=0,scale=1)
          @style = style
          @base = base
          @index = index
          @scale = scale
        end

        def ==(other)
          return false unless @base==other.base
          return false unless @index==other.index
          return @scale==other.scale
        end

        def +(disp)
          self.new(@base,@index+disp,@scale)
        end

        def *(scale)
          self.new(@base,@index,@scale+scale)
        end

        def compile
          compile_scale = lambda {
            if @scale==1
              ''
            else
              ",#{@scale}"
            end
          }

          compile_index = lambda {
            if @index==0
              if @scale==1
                ''
              else
                ','
              end
            else
              ",#{@index}"
            end
          }

          return "(#{@base}#{compile_index.call}#{compile_scale.call})"
        end

      end
    end
  end
end
