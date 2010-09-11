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

module Ronin
  module Engine
    module InstanceMethods
      #
      # Initializes the Ronin Engine.
      #
      # @param [Hash] attributes
      #   The attributes or parameter values to initialize the engine with.
      #
      # @since 0.4.0
      #
      def initialize(attributes={})
        super(attributes)

        initialize_params(attributes)
      end

      #
      # Inspects both the properties and parameters of the Ronin Engine.
      #
      # @return [String]
      #   The inspected Ronin Engine.
      #
      # @since 0.4.0
      #
      def inspect
        body = ''

        attribute_pairs = []

        self.attributes.each do |name,value|
          attribute_pairs << "#{name}: #{value.inspect}"
        end

        body << attribute_pairs.join(', ')

        param_pairs = []

        self.params.each do |name,param|
          param_pairs << "#{name}: #{param.value.inspect}"
        end

        body << " params: {#{param_pairs.join(', ')}}"

        return "#<#{self.class}: #{body}>"
      end
    end
  end
end
