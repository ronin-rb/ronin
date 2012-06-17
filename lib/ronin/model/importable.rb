#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  module Model
    #
    # Uses the `extract` method to extract and save resources from the
    # contents of text-files.
    #
    # @since 1.3.0
    #
    module Importable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        #
        # Extracts and imports resources from the given file.
        #
        # @param [String] path
        #   The path of the file.
        #
        # @yield [resource]
        #   The given block will be passed every imported resource.
        #
        # @yieldparam [Model] resource
        #   A successfully imported resource.
        #
        # @return [Array<Model>]
        #   If no block is given, an Array of imported resources is returned.
        #
        # @api public
        #
        def import(path)
          return enum_for(__method__,path).to_a unless block_given?

          File.open(path) do |file|
            file.each_line do |line|
              extract(line) do |resource|
                yield(resource) if resource.save
              end
            end
          end
        end
      end
    end
  end
end
