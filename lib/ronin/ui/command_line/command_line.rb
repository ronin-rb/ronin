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

require 'ronin/ui/command_line/exceptions/unknown_command'
require 'ronin/ui/command_line/commands/console'
require 'ronin/ui/console'

require 'reverse_require'

module Ronin
  module UI
    module CommandLine
      #
      # Returns the commands registered with the command-line utility.
      #
      def CommandLine.commands
        unless class_variable_defined?('@@ronin_commands')
          paths = Gem.find_resources_for('ronin','bin/ronin-*')
          
          @@ronin_commands = {}
            
          paths.each do |path|
            next unless File.executable?(path)
            name = File.basename(path).gsub(/^ronin-/,'')

            @@ronin_commands[name] = path
          end
        end

        return @@ronin_commands
      end

      #
      # Returns +true+ if the a Command with the specified _name_ was
      # registered with the command-line utility.
      #
      def CommandLine.has_command?(name)
        CommandLine.commands.has_key?(name.to_s)
      end

      #
      # Returns the Command registered with the command-line utility
      # with the specified _name_.
      #
      def CommandLine.get_command(name)
        name = name.to_s

        unless CommandLine.has_command?(name)
          raise(UnknownCommand,"unknown command #{name.dump}",caller)
        end

        return CommandLine.commands[name]
      end

      #
      # Runs the command-line utility with the given _argv_ Array. If the
      # first argument is a sub-command name, the command-line utility will
      # attempt to find and execute the Command with the same name.
      #
      def CommandLine.run(*argv)
        if (argv.empty? || argv[0][0..0]=='-')
          ConsoleCommand.run(*argv)
        else
          cmd = argv.first
          argv = argv[1..-1]

          begin
            exec(CommandLine.get_command(cmd),*argv)
          rescue UnknownCommand => e
            STDERR.puts excp
            exit -1
          end
        end

        return true
      end
    end
  end
end
