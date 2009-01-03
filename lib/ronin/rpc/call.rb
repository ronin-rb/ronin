#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/rpc/exceptions/not_implemented'

module Ronin
  module RPC
    class Call

      # Name of the function to call
      attr_reader :name

      # Arguments to call with the function
      attr_reader :arguments

      #
      # Creates a new Call object with the specified _name_ and the given
      # _arguments_.
      #
      def initialize(name,*arguments)
        @name = name
        @arguments = arguments
      end

      #
      # Default method which encodes the call object into a format parsable
      # by the RPC Server. By default encode raises a NotImplemented
      # exception.
      #
      def encode
        raise(NotImplemented,"the \"encode\" method is not implemented in #{self.class}",caller)
      end

      #
      # Returns the String form of the call object.
      #
      def to_s
        args = @arguments.map { |arg|
          if (arg.kind_of?(Hash) || arg.kind_of?(Array))
            arg.inspect
          elsif arg.kind_of?(String)
            arg.dump
          else
            arg
          end
        }

        "#{@name}(" + args.join(', ') + ')'
      end

      alias inspect to_s

    end
  end
end
