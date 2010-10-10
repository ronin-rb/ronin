#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/rpc/exceptions/response_missing'
require 'ronin/rpc/service'
require 'ronin/extensions/meta'

module Ronin
  module RPC
    class Client

      #
      # Calls the specified _function_ hosted on the RPC Server with the
      # given _arguments_. Returns the return-value of the RPC function call.
      #
      def call(function,*arguments)
        return_value(send_call(create_call(function,*arguments)))
      end

      protected

      #
      # Defines a Service offered by the Client with the specified _name_
      # and _class_type_.
      #
      def self.service(name,class_type)
        name = name.to_sym

        class_def(name) do
          class_type.new(name,self)
        end
      end

      #
      # Default method which creates a Call object for the specified
      # _function_ and the given _arguments_. By default create_call raises
      # a NotImplementedError exception.
      #
      def create_call(function,*arguments)
        raise(NotImplementedError,"the \"create_call\" method is not implemented in #{self.class}")
      end

      #
      # Default method which sends the _call_object_ to the RPC Server and 
      # returns the response of the Server. By default send_call raises
      # a NotImplementedError exception.
      #
      def send_call(call_object)
        raise(NotImplementedError,"the \"send_call\" method is not implemented in #{self.class}")
      end

      #
      # Default method which extracts the return-value and output generated
      # by the RPC function call from the specified _response_ data. By
      # default return_value raises a NotImplementedError exception.
      #
      def return_value(response)
        raise(NotImplementedError,"the \"return_value\" method is not implemented in #{self.class}")
      end

      #
      # Relays missing methods to call.
      #
      def method_missing(sym,*args)
        call(sym,*args)
      end

    end
  end
end
