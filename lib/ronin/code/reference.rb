#
# Ronin - A Ruby platform for exploit development and security research.
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

module Ronin
  module Code
    class Reference

      # Object that is being referenced
      attr_accessor :value

      #
      # Creates a new Reference object with the specified _value_ that will
      # be referenced.
      #
      def initialize(value=nil)
        @value = value
      end

      #
      # Returns the class of the referenced object.
      #
      def class
        @value.class
      end

      #
      # Returns +true+ if the referenced object is a kind of _base_ class,
      # returns +false+ otherwise.
      #
      def is_a?(base)
        @value.is_a?(base) || super(base)
      end

      #
      # Returns +true+ if the referenced object is a kind of _base_ class,
      # returns +false+ otherwise.
      #
      def kind_of?(base)
        @value.kind_of?(base) || super(base)
      end

      #
      # Returns +true+ if the referenced object is an instance of the
      # specified _base_ class, returns +false+ otherwise.
      #
      def instance_of?(base)
        @value.instance_of?(base) || super(base)
      end

      #
      # Returns +true+ if the referenced object responds to the specified
      # method _name_, returns +false+ otherwise.
      #
      def respond_to?(name)
        @value.respond_to?(name) || super(name)
      end

      #
      # Extends the referenced object with the specified _base_ module.
      #
      def extend(base)
        @value.extend(base) if @value
        return self
      end

      #
      # Evaluates the given _block_ within the referenced object.
      #
      def instance_eval(&block)
        @value.instance_eval(&block)
      end

      #
      # Returns +true+ if the referenced object equals the specified
      # _value_, returns +false+ otherwise.
      #
      def eql?(value)
        @value.eql?(value) || super(value)
      end

      alias == eql?
      alias === eql?

      #
      # Returns the String form of the referenced object.
      #
      def to_s
        @value.to_s
      end

      #
      # Inspects the referenced object.
      #
      def inspect
        @value.inspect
      end

      protected

      #
      # Relays method calls to the referenced object.
      #
      def method_missing(name,*arguments,&block)
        if @value.class.public_method_defined?(name)
          return @value.send(name,*arguments,&block)
        end

        super(name,*arguments,&block)
      end

    end
  end
end
