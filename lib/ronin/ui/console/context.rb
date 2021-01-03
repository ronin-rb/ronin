#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

module Ronin
  module UI
    module Console
      #
      # @since 1.2.0
      #
      class Context

        #
        # Creates a new {Console} context.
        #
        # @return [Class<Context>]
        #   A new context for the {Console}.
        #
        def self.new
          class << super; self; end
        end

        class << self
          #
          # Catches missing constants and searches the {Ronin} namespace.
          #
          # @param [Symbol] name
          #   The constant name.
          #
          # @return [Object]
          #   The found constant.
          #
          # @raise [NameError]
          #   The constant could not be found within {Ronin}.
          #
          # @since 1.0.0
          #
          # @api semipublic
          #
          def self.const_missing(name)
            Ronin.send(:const_missing,name)
          end

          #
          # @note
          #   Ruby 1.8.x requires {const_missing} to be defined as an
          #   instance-method.
          #
          def const_missing(name)
            Ronin.send(:const_missing,name)
          end

          #
          # Populates the instance variables.
          #
          # @param [Hash] variables
          #   The variable names and values.
          #
          def instance_variables=(variables)
            variables.each do |name,value|
              instance_variable_set(:"@#{name}",value)
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
            unless instance_variables.empty?
              body = ':'

              instance_variables.each do |name|
                body << " #{name}=#{instance_variable_get(name).inspect}"
              end
            end

            return "#<Ronin::UI::Console#{body}>"
          end
        end

      end
    end
  end
end
