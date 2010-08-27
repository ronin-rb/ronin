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
  module Platform
    module Cacheable
      module ClassMethods
        #
        # Loads all objects with the matching attributes.
        #
        # @param [Hash] attributes
        #   Attributes to search for.
        #
        def load_all(attributes={})
          self.all(attributes).each { |obj| obj.load_original! }
        end

        #
        # Loads the first object with matching attributes.
        #
        # @param [Hash] attributes
        #   Attributes to search for.
        #
        # @yield [objs]
        #   If a block is given, it will be passed all matching
        #   objects to be filtered down. The first object from the
        #   filtered objects will end up being selected.
        #
        # @yieldparam [Array<Cacheable>] objs
        #   All matching objects.
        #
        # @return [Cacheable]
        #   The loaded cached objects.
        #
        def load_first(attributes={},&block)
          obj = if block
                  objs = self.all(attributes)

                  (block.call(objs) || objs).first
                else
                  self.first(attributes)
                end

          obj.load_original! if obj
          return obj
        end
      end
    end
  end
end
