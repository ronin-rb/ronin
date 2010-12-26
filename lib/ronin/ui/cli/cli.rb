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

require 'ronin/ui/cli/exceptions/unknown_command'
require 'ronin/ui/cli/commands'
require 'ronin/installation'

module Ronin
  module UI
    #
    # The {CLI} provides an extendable Command Line Interface (CLI)
    # for Ronin. The {CLI} can load any sub-command using the
    # {command} method, from the `ronin/ui/cli/commands`
    # directory.
    #
    module CLI
      # Name of the default to run
      DEFAULT_COMMAND = 'console'

      @commands = {}

      #
      # All command-line names of Commands available to the {CLI}.
      #
      # @return [Hash]
      #   The command-line names and paths of available Command classes.
      #
      # @since 1.0.0
      #
      def CLI.commands
        if @commands.empty?
          commands_dir = File.join('lib',Commands.namespace_root)

          Installation.each_file(commands_dir) do |path|
            # remove the .rb file extension
            name = path.chomp('.rb')

            # replace any file separators with a ':', to mimic the
            # naming convention of Rake/Thor.
            name.tr!(File::SEPARATOR,':')
            
            # replace all '_' and '-' characters with a single '_' character
            name.gsub!(/[_-]+/,'_')

            @commands[name] = path
          end
        end

        return @commands
      end

      #
      # Searches for a {Command} class with the matching name.
      #
      # @param [String, Symbol] name
      #   The command-line name of the command to search for.
      #
      # @return [Command]
      #   The Command registered with the command-line utility with the
      #   matching command-line name.
      #
      # @raise [UnknownCommand]
      #   No valid command could be found or loaded with the matching
      #   command-line name.
      #
      # @example
      #   CLI.command('auto_hack')
      #   # => Ronin::UI::CLI::Commands::AutoHack
      #
      # @example
      #   CLI.command('auto-hack')
      #   # => Ronin::UI::CLI::Commands::AutoHack
      #
      # @since 1.0.0
      #
      def CLI.command(name)
        name = name.to_s

        # eventually someone is going to use a space or - which is going
        # mess things up we will take care of this ahead of time here
        name = name.gsub(/[\s_-]+/, '_')

        unless (command = Commands.require_const(name))
          raise(UnknownCommand,"unable to load the command #{name.dump}",caller)
        end

        unless command.respond_to?(:start)
          raise(UnknownCommand,"command #{name.dump} must provide a 'start' method",caller)
        end

        return command
      end

      #
      # Runs the command-line utility. If the first argument is a Command
      # name, the {CLI} will attempt to find and run the command with the
      # matching command-line name. If the first argument is an option,
      # or there are no arguments, the {DEFAULT_COMMAND} will be ran.
      #
      # @param [Array] argv
      #   Command-line arguments which are used to select the Command to
      #   run, and which will be passed to the Command.
      #
      # @return [true]
      #   The command was successfully ran.
      #
      # @since 1.0.0
      #
      def CLI.start(argv=ARGV)
        if (argv.empty? || argv.first[0,1]=='-')
          # run the default command if an option or no arguments were given
          name = DEFAULT_COMMAND
        else
          name = argv.first

          if File.file?(name)
            # run the default command if the sub-command is a file
            name = DEFAULT_COMMAND
          else
            argv = argv[1..-1]
          end
        end

        begin
          CLI.command(name).start(argv)
        rescue UnknownCommand => e
          STDERR.puts e
          exit -1
        end

        return true
      end
    end
  end
end
