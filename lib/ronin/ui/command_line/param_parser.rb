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

require 'uri'

module Ronin
  module UI
    module CommandLine
      module ParamParser
        # Hash of format patterns and their parsers
        FORMATS = {
          /^[0-9]+$/ => lambda { |value| value.to_i },
          /^0x[0-9a-fA-F]+$/ => lambda { |value| value.hex },
          /^[a-zA-Z][a-zA-Z0-9]*:\/\// => lambda { |value| URI(value) },
          'true' => lambda { |value| true },
          'false' => lambda { |value| false }
        }

        # The params Hash
        attr_reader :params

        #
        # Creates an empty +params+ Hash.
        #
        def initialize
          @params = {}
        end

        #
        # Parses the specified _name_and_value_ string of the form
        # "name=value" and extracts both the _name_ and the _value_, saving
        # both the _name_ and _value_ within the +params+ Hash. If the
        # extracted _value_ matches one of the patterns within +FORMATS+,
        # then the associated parser will first parse the _value_.
        #
        def parse_param(name_and_value)
          name, value = name_and_value.split('=',2)

          if value
            FORMATS.each do |pattern,parser|
              if value.match(pattern)
                value = parser.call(value)
                break
              end
            end
          end

          @params[name.to_sym] = value
        end
      end
    end
  end
end
