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

require 'asm/type'
require 'asm/block'

module Ronin
  module Asm

    class Arg < Type

      # Type of argument
      attr_reader :type

      # Name of the argument
      attr_reader :name

      def initialize(type,name)
	@type = type
	@name = name
      end

      def to_s
	@name.id2name
      end

    end

    class Func < Block

      # Name of the function
      attr_reader :name

      # Arguments of the function
      attr_reader :args

      def initialize(arch_target,name,*args,&block)
	@name = name
	@args = args

	super(arch_target,&block)
      end

    end
  end
end
