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

require 'ronin/code/datatype'
require 'ronin/code/variable'
require 'ronin/code/struct'
require 'ronin/code/union'

module Ronin
  module Code
    class DataBlock

      # Members of the group
      attr_reader :members

      def initialize(&block)
        @members = {}
        instance_eval(&block) if block
      end

      def char(name)
        add_member(DataType::CHAR,name)
      end

      def int(name)
        add_member(DataType::INT,name)
      end

      def int8(name)
        add_member(DataType::INT8,name)
      end

      def int16(name)
        add_member(DataType::INT16,name)
      end

      def int32(name)
        add_member(DataType::INT32,name)
      end

      def int64(name)
        add_member(DataType::INT64,name)
      end

      def string(name)
        add_member(DataType::STRING,name)
      end

      def pointer(name)
        add_member(DataType::POINTER,name)
      end

      def struct(type,name=nil)
        @members[name] = Variable.new(Struct.new(type),name)
      end

      def union(type,name=nil)
        @members[name] = Variable.new(Union.new(type),name)
      end

      def add_member(type,name=nil)
        @members[name] = Variable.new(type,name)
      end

      protected

      def method_missing(sym,*args)
        add_member(sym,args)
      end
    end

    def data(&block)
      DataBlock.new(&block)
    end

  end
end
