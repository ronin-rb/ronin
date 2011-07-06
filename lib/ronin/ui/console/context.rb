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
  module UI
    module Console
      #
      # @since 1.2.0
      #
      class Context

        class << self
          #
          # Populates the instance variables.
          #
          # @param [Hash] variables
          #   The variable naems and values.
          #
          def instance_variables=(variables)
            variables.each do |name,value|
              instance_variable_set("@#{name}".to_sym,value)
            end
          end

          #
          # Inspects the console.
          #
          # @return [String]
          #   The inspected console.
          #
          # @since 1.0.0
          #
          # @api semipublic
          #
          def inspect
            "#<Ronin::UI::Console>"
          end
        end

      end
    end
  end
end
