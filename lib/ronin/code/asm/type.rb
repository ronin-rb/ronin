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

require 'ronin/code/asm/exceptions/unresolved'

module Ronin
  module Asm
    class Type

      def is_resolved?
        return true
      end

      def resolve(block)
        return self
      end

      def compile(context)
      end

    end

    protected

    def resolved?(obj)
      if obj.kind_of?(Symbol)
        return false
      elsif obj.kind_of?(Type)
        return false unless obj.is_resolved?
      end
      return true
    end
  end
end
