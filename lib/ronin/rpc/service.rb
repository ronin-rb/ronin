#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module RPC
    class Service

      # Name of the service
      attr_reader :name

      # The client object
      attr_reader :client

      #
      # Creates a new Service object with the specified _name_ and _client_.
      #
      def initialize(name,client)
        @name = name
        @client = client
      end

      def call(sym,*args)
        @client.call("#{@name}.#{sym}",*args)
      end

      #
      # Returns the name of the service.
      #
      def to_s
        @name.to_s
      end

      protected

      def method_missing(sym,*args)
        call(sym,*args)
      end

    end
  end
end
