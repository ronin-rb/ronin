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
  module Model
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
