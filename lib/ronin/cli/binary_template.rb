# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/binary/template'

module Ronin
  class CLI
    #
    # Module for commands that uses [Ronin::Support::Binary::Template].
    #
    # [Ronin::Support::Binary::Template]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Template.html
    #
    # @since 2.1.0
    #
    module BinaryTemplate
      #
      # Adds the `--endian`, `--arch`, and `--os` options to the command
      # class including {BinaryTemplate}.
      #
      # @param [Class<Command>] command
      #   The command class including {BinaryTemplate}.
      #
      def self.included(command)
        command.option :endian, short: '-E',
                                value: {
                                  type: [:little, :big, :net]
                                },
                                desc: 'Sets the endianness'

        command.option :arch, short: '-A',
                              value: {
                                type: [
                                  :x86, :x86_64,
                                  :ppc, :ppc64,
                                  :mips, :mips_le, :mips_be,
                                  :mips64, :mips64_le, :mips64_be,
                                  :arm, :arm_le, :arm_be,
                                  :arm64, :arm64_le, :arm64_be
                                ]
                              },
                              desc: 'Sets the architecture'

        command.option :os, short: '-O',
                            value: {
                              type: [
                                :linux,
                                :macos,
                                :windows,
                                :android,
                                :apple_ios,
                                :bsd,
                                :freebsd,
                                :openbsd,
                                :netbsd
                              ]
                            },
                            desc: 'Sets the OS'
      end

      #
      # Parses a type string.
      #
      # @param [String] string
      #   The raw type signature to parse.
      #
      # @return [Symbol, (Symbol, Integer)]
      #   The parsed type signature.
      #
      def parse_type(string)
        unless (match = string.match(/\A(?<type>[a-z0-9_]+)(?:\[(?<array_size>\d*)\])?\z/))
          print_error "invalid type: #{string}"
          exit(-1)
        end

        type       = match[:type].to_sym
        array_size = match[:array_size]

        if array_size && array_size.empty?
          # unbounded array
          type = (type..)
        elsif array_size
          # sized array
          type = [type, array_size.to_i]
        end

        return type
      end

      #
      # Builds a binary template for the given types and for the optional
      # `--endian`, `--arch`, and `--os` options.
      #
      # @param [Array<Symbol, (Symbol, Integer)>] types
      #   The types for each field in the binary template.
      #
      # @return [Ronin::Support::Binary::Template]
      #   The binary template.
      #
      def build_template(types)
        Support::Binary::Template.new(types, endian: options[:endian],
                                             arch:   options[:arch],
                                             os:     options[:os])
      rescue ArgumentError => error
        print_error(error.message)
        exit(1)
      end
    end
  end
end
