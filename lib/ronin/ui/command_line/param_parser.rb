#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
        # The params Hash
        attr_reader :params

        #
        # The Array of parameter patterns and their parsers.
        #
        def ParamParser.formats
          @@ronin_param_formats ||= []
        end

        #
        # Itereates over each parameter pattern and parser, passing them to the
        # specified _block_.
        #
        def ParamParser.each_format(&block)
          ParamParser.formats.each do |format|
            block.call(format[:pattern],format[:parser])
          end
        end

        #
        # Adds a new parameter _pattern_ using the specified _block_ as the parser.
        #
        def ParamParser.recognize(pattern,&block)
          ParamParser.formats.unshift({
            :pattern => pattern,
            :parser => block
          })
        end

        protected

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
            ParamParser.each_format do |pattern,parser|
              if value.match(pattern)
                value = parser.call(value)
                break
              end
            end
          end

          return {name.to_sym => value}
        end

        ParamParser.recognize(/^[a-zA-Z][a-zA-Z0-9]*:\/\//) { |value| URI(value) }
        ParamParser.recognize('false') { |value| false }
        ParamParser.recognize('true') { |value| true }
        ParamParser.recognize(/^0x[0-9a-fA-F]+$/) { |value| value.hex }
        ParamParser.recognize(/^[0-9]+$/) { |value| value.to_i }

      end
    end
  end
end
