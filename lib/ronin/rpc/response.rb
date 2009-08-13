#
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
#

require 'ronin/rpc/exceptions/not_implemented'

module Ronin
  module RPC
    class Response

      # Contents of the response
      attr_reader :contents

      #
      # Creates a new Response object with the specified _contents_.
      #
      def initialize(contents)
        @contents = contents
      end

      #
      # Default method which decodes response data from the contes of the
      # RPC response.
      #
      def decode
        raise(NotImplemented,"the \"decode\" method is not implemented in #{self.class}",caller)
      end

      #
      # Returns the String form of the contents of the RPC response.
      #
      def to_s
        @contents.to_s
      end

    end
  end
end
