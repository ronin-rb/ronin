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

require 'ronin/code/asm/block'

module Ronin
  module Code
    module ASM
      class Label < Block

        # The name of the label
        attr_accessor :name

        def initialize(name,style,&block)
          @name = name.to_sym

          super(style,&block)
        end

        def compile
          [@name.to_s] + @elements.map { |elem| "\t#{elem}" }
        end

        def ==(label)
          return false unless @name==label.name

          return super(label)
        end

        def to_s
          @name.to_s
        end

      end
    end
  end
end
