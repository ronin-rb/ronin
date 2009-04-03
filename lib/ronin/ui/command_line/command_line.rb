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
require 'extlib'

module Ronin
  module UI
    module CommandLine
      # Directory which stores the commands
      COMMANDS_DIR = File.join('ronin','ui','command_line','commands')

      # Name of the default to run
      DEFAULT_COMMAND = 'console'

      #
      # Returns the commands registered with the command-line utility.
      #
      def CommandLine.commands
        unless class_variable_defined?('@@ronin_commands')
          pattern = File.join('lib',COMMANDS_DIR,'*.rb')
          paths = Gem.find_resources(pattern)
          
          @@ronin_commands = {}
            
          paths.each do |path|
            name = File.basename(path).gsub(/\.rb$/,'')

            @@ronin_commands[name] = File.join(COMMANDS_DIR,name)
          end
        end

        return @@ronin_commands
      end

      #
      # Returns the Command registered with the command-line utility
      # with the specified _name_.
      #
      def CommandLine.get_command(name)
        name = name.to_s

        begin
          require File.join(COMMANDS_DIR,name)
        rescue LoadError
          raise(UnknownCommand,"unable to load the command #{name.dump}",caller)
        end

        class_name = name.to_const_string

        unless Commands.const_defined?(class_name)
          raise(UnknownCommand,"unknown command #{name.dump}",caller)
        end

        return Commands.const_get(class_name)
      end

      #
      # Runs the command-line utility with the given _argv_ Array. If the
      # first argument is a sub-command name, the command-line utility will
      # attempt to find and execute the Command with the same name.
      #
      def CommandLine.run(*argv)
        if (argv.empty? || argv.first[0..0]=='-')
          name = DEFAULT_COMMAND
          argv = ARGV
        else
          name = argv.first
          argv = argv[1..-1]
        end

        begin
          CommandLine.get_command(name).run(*argv)
        rescue UnknownCommand => e
          STDERR.puts e
          exit -1
        end

        return true
      end
    end
  end
end
