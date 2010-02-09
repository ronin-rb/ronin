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

require 'ronin/ui/command_line/exceptions/unknown_command'
require 'ronin/extensions/kernel'
require 'ronin/ronin'

require 'set'

module Ronin
  module UI
    module CommandLine
      # Directory which stores the commands
      COMMANDS_DIR = File.join('ronin','ui','command_line','commands')

      # Name of the default to run
      DEFAULT_COMMAND = 'console'

      #
      # All command-line names of Commands available to the CommandLine.
      #
      # @return [Array]
      #   The command-line names of available Command classes.
      #
      def CommandLine.commands
        unless class_variable_defined?('@@ronin_commands')
          @@ronin_commands = SortedSet[]

          pattern = File.join('lib',COMMANDS_DIR,'*.rb')

          Ronin.find_files(pattern).each do |path|
            @@ronin_commands << File.basename(path).gsub(/\.rb$/,'')
          end
        end

        return @@ronin_commands
      end

      #
      # Searches for the command with the matching name.
      #
      # @param [String, Symbol] name
      #   The name of the command to search for.
      #
      # @return [Boolean]
      #   Specifies whether a command exists with the matching name.
      #
      def CommandLine.has_command?(name)
        CommandLine.commands.include?(name.to_s)
      end

      #
      # Searches for a Command class with the matching command-line name.
      #
      # @param [String, Symbol] name
      #   The command-line name of the command to search for.
      #
      # @return [Ronin::UI::Command]
      #   The Command registered with the command-line utility with the
      #   matching command-line name.
      #
      # @raise [UnknownCommand]
      #   No valid command could be found or loaded with the matching
      #   command-line name.
      #
      # @example
      #   CommandLine.get_command('gen_overlay')
      #   # => Ronin::UI::CommandLine::Commands::GenOverlay
      #
      # @example
      #   CommandLine.get_command('gen-overlay')
      #   # => Ronin::UI::CommandLine::Commands::GenOverlay
      #
      def CommandLine.get_command(name)
        name = name.to_s

        # eventually someone is going to use a space or - which is going
        # mess things up we will take care of this ahead of time here
        name.gsub!(/[\s_-]+/, '_')

        unless (command = require_within(COMMANDS_DIR,name))
          raise(UnknownCommand,"unable to load the command #{name.dump}",caller)
        end

        unless command.respond_to?(:start)
          raise(UnknownCommand,"command #{name.dump} must provide a 'start' method",caller)
        end

        return command
      end

      #
      # Runs the CommandLine utility. If the first argument is a Command
      # name, the CommandLine utility will attempt to find and run
      # the Command with the matching command-line name. If the first
      # argument is an option, or there are no arguments, the
      # `DEFAULT_COMMAND` will be ran.
      #
      # @param [Array] argv
      #   Command-line arguments which are used to select the Command to
      #   run, and which will be passed to the Command.
      #
      # @return [true]
      #   The command was successfully ran.
      #
      def CommandLine.start(argv=ARGV)
        if (argv.empty? || argv.first[0,1]=='-')
          name = DEFAULT_COMMAND
        else
          name = argv.first
          argv = argv[1..-1]
        end

        begin
          CommandLine.get_command(name).start(argv)
        rescue UnknownCommand => e
          STDERR.puts e
          exit -1
        end

        return true
      end
    end
  end
end
