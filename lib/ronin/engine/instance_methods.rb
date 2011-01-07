#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
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
      # @since 1.0.0
      #
      def initialize(attributes={})
        super(attributes)

        initialize_params(attributes)
      end

      #
      # The engine type.
      #
      # @return [String]
      #   The name of the engine class.
      #
      # @since 1.0.0
      #
      def engine_name
        @ngine_name ||= self.class.base_model.name.split('::').last
      end

      #
      # Converts the engine to a String.
      #
      # @return [String]
      #   The name and version of the engine.
      #
      # @since 1.0.0
      #
      def to_s
        if (self.name && self.version)
          "#{self.name} #{self.version}"
        elsif self.name
          super
        elsif self.version
          self.version.to_s
        end
      end

      #
      # Inspects both the properties and parameters of the Ronin Engine.
      #
      # @return [String]
      #   The inspected Ronin Engine.
      #
      # @since 1.0.0
      #
      def inspect
        body = []

        self.attributes.each do |name,value|
          body << "#{name}: #{value.inspect}"
        end

        param_pairs = []

        self.params.each do |name,param|
          param_pairs << "#{name}: #{param.value.inspect}"
        end

        body << "params: {#{param_pairs.join(', ')}}"

        return "#<#{self.class}: #{body.join(', ')}>"
      end
    end
  end
end
