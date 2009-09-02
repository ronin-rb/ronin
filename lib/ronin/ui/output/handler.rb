#
# Ronin - A Ruby platform for exploit development and security research.
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
#

require 'thor/shell/basic'
require 'thor/shell/color'

module Ronin
  module UI
    module Output
      module Handler
        #
        # The shell to use for output.
        #
        # @since 0.3.0
        #
        def self.shell
          @@ronin_output_shell ||= Thor::Shell::Color.new
        end

        #
        # Changes color output.
        #
        # @param [true, false] mode The new color mode.
        # @return [true, false] The new color mode.
        #
        # @since 0.3.0
        #
        def Handler.color=(mode)
          if mode
            @@ronin_output_shell = Thor::Shell::Color.new
          else
            @@ronin_output_shell = Thor::Shell::Basic.new
          end

          return mode
        end

        #
        # Prints one or more messages.
        #
        # @param [Array] messages The messages to print.
        #
        # @since 0.3.0
        #
        def self.puts(*messages)
          shell.say messages.join($\)
        end

        #
        # Prints one or more messages as +info+ messages.
        #
        # @param [Array] messages The messages to print.
        #
        # @since 0.3.0
        #
        def self.print_info(*messages)
          shell.say messages.map { |mesg| "[-] #{mesg}" }.join($\), :green
        end

        #
        # Prints one or more messages as +debug+ mssages.
        #
        # @param [Array] messages The messages to print.
        #
        # @since 0.3.0
        #
        def self.print_debug(*messages)
          shell.say messages.map { |mesg| "[+] #{mesg}" }.join($\), :cyan
        end

        #
        # Prints one or more messages as +warning+ mssages.
        #
        # @param [Array] messages The messages to print.
        #
        # @since 0.3.0
        #
        def self.print_warning(*messages)
          shell.say messages.map { |mesg| "[*] #{mesg}" }.join($\), :yellow
        end

        #
        # Prints one or more messages as +error+ mssages.
        #
        # @param [Array] messages The messages to print.
        #
        # @since 0.3.0
        #
        def self.print_error(*messages)
          shell.say messages.map { |mesg| "[!] #{mesg}" }.join($\), :red
        end

      end
    end
  end
end
