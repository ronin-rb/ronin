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
  module Script
    module ClassMethods
      #
      # Loads the {Script} of the same class.
      #
      # @param [String] path
      #   The path to load the script from.
      #
      # @return [Script]
      #   The loaded script.
      #
      # @example
      #   Exploits::HTTP.load_from('mod_php_exploit.rb')
      #   # => #<Ronin::Exploits::HTTP: ...>
      #
      # @since 1.1.0
      #
      def load_from(path)
        load_object(path)
      end

      #
      # Loads all objects with the matching attributes.
      #
      # @param [Hash] attributes
      #   Attributes to search for.
      #
      # @since 1.0.0
      #
      # @api public
      #
      def load_all(attributes={})
        resources = all(attributes)
        resources.each { |resource| resource.load_code! }

        return resources
      end

      #
      # Loads the first object with matching attributes.
      #
      # @param [Hash] attributes
      #   Attributes to search for.
      #
      # @return [Cacheable]
      #   The loaded cached objects.
      #
      # @since 1.0.0
      #
      # @api public
      #
      def load_first(attributes={})
        if (resource = first(attributes))
          resource.load_code!
        end

        return resource
      end
    end
  end
end
