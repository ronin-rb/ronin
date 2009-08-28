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

require 'ronin/ui/command_line/exceptions/unknown_command'

require 'reverse_require'
require 'extlib'

module Ronin
  module UI
    module CommandLine
      # Directory which stores the commands
      COMMANDS_DIR = File.join('ronin','ui','command_line','commands')

      # Name of the default to run
      DEFAULT_COMMAND = 'console'

      #
      # @return [Array] The commands registered with the command-line
      #                 utility.
      #
      def CommandLine.commands
        unless class_variable_defined?('@@ronin_commands')
          pattern = File.join('lib',COMMANDS_DIR,'*.rb')
          paths = Gem.find_resources(pattern)
          
          @@ronin_commands = []
            
          paths.each do |path|
            name = File.basename(path).gsub(/\.rb$/,'')

            @@ronin_commands << name unless @@ronin_commands.include?(name)
          end
        end

        return @@ronin_commands
      end

      #
      # Searches for the command with the matching _name_.
      #
      # @param [String, Symbol] name The name of the command to search for.
      #
      # @return [true, false] Specifies whether a command exists with the
      #                       matching _name_.
      #
      def CommandLine.has_command?(name)
        CommandLine.commands.include?(name.to_s)
      end

      #
      # Searches for a Command class with the matching command-line
      # _name_.
      #
      # @param [String, Symbol] The command-line name of the command to
      #                         search for.
      #
      # @return [Ronin::UI::Command] The Command registered with the
      #                              command-line utility with the
      #                              matching command-line _name_.
      #
      # @raise [UnknownCommand] No valid command could be found or loaded
      #                         with the matching command-line _name_.
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
        name.gsub!(/[\s-]/, '_')

        begin
          require File.join(COMMANDS_DIR,name)
        rescue Gem::LoadError => e
          raise(e)
        rescue ::LoadError
          raise(UnknownCommand,"unable to load the command #{name.dump}",caller)
        end

        class_name = name.to_const_string

        unless Commands.const_defined?(class_name)
          raise(UnknownCommand,"unknown command #{name.dump}",caller)
        end

        command = Commands.const_get(class_name)

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
      # +DEFAULT_COMMAND+ will be ran.
      #
      # @param [Array] argv Command-line arguments which are used to
      #                     select the Command to run, and which will be
      #                     passed to the Command.
      #
      def CommandLine.start(argv=ARGV)
        if (argv.empty? || argv.first[0..0]=='-')
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
