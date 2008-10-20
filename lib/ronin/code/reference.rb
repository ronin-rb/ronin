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
  module Code
    class Reference

      # Object that is being referenced
      attr_accessor :value

      #
      # Creates a new Reference object referencing the specified _value_.
      #
      def initialize(value=nil)
        @value = value
      end

      def kind_of?(type)
        @value.kind_of?(type) || super(type)
      end

      def respond_to?(name)
        @value.respond_to?(name) || super(name)
      end

      def eval(code,&block)
        @value.eval(code,&block)
      end

      def instance_eval(&block)
        @value.instance_eval(&block)
      end

      def to_s
        @value.to_s
      end

      def inspect
        @value.inspect
      end

      protected

      def method_missing(name,*arguments,&block)
        if @value.class.public_method_defined?(name)
          return @value.send(name,*arguments,&block)
        end

        raise(NoMethodError,name.id2name)
      end

    end
  end
end
