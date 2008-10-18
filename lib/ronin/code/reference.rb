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
      attr_accessor :object

      #
      # Creates a new Reference object referencing the specified _object_.
      #
      def initialize(object=nil)
        @object = object
      end

      def eval(code,&block)
        @object.eval(code,&block)
      end

      def instance_eval(&block)
        @object.instance_eval(&block)
      end

      def to_s
        @object.to_s
      end

      def inspect
        @object.inspect
      end

      protected

      def method_missing(name,*arguments,&block)
        if @object.public_instance_method(name)
          return @object.send(name,*arguments,&block)
        end

        raise(NoMethodError,name.id2name)
      end

    end
  end
end
