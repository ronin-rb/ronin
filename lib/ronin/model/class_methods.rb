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

require 'ronin/support/inflector'

module Ronin
  module Model
    #
    # Class methods that are added when {Model} is included into a class.
    #
    module ClassMethods
      #
      # The default name to use when defining relationships with the
      # model.
      #
      # @return [Symbol]
      #   The name to use in relationships.
      #
      # @since 1.0.0
      #
      def relationship_name
        self.name.split('::').last.underscore.pluralize.to_sym
      end

      #
      # Loads and initialize the resources.
      #
      def load(records,query)
        resources = super(records,query)
        resources.each { |resource| resource.send :initialize }

        return resources
      end
    end
  end
end
