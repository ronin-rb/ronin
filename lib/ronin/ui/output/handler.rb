#
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
        # Enables color output.
        #
        # @since 0.3.0
        #
        def Handler.color!
          @@ronin_output_shell = Thor::Shell::Color.new
          return true
        end

        #
        # Disables color output.
        #
        # @since 0.3.0
        #
        def Handler.no_color!
          @@ronin_output_shell = Thor::Shell::Basic.new
          return false
        end

        #
        # Prints the given _messages_.
        #
        # @since 0.3.0
        #
        def self.puts(*messages)
          shell.say messages.join($\)
        end

        #
        # Prints the given _messages_ as info diagnostics.
        #
        # @since 0.3.0
        #
        def self.print_info(*messages)
          shell.say messages.map { |mesg| "[-] #{mesg}" }.join($\), :green
        end

        #
        # Prints the given _messages_ as debugging diagnostics,
        # if verbose output was enabled.
        #
        # @since 0.3.0
        #
        def self.print_debug(*messages)
          shell.say messages.map { |mesg| "[+] #{mesg}" }.join($\), :cyan
        end

        #
        # Prints the given _messages_ as warning diagnostics,
        # if verbose output was enabled.
        #
        # @since 0.3.0
        #
        def self.print_warning(*messages)
          shell.say messages.map { |mesg| "[*] #{mesg}" }.join($\), :yellow
        end

        #
        # Prints the given _messages_ as error diagnostics.
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
