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

require 'ronin/ui/command_line/command'
require 'ronin/ui/command_line/commands/default'
require 'ronin/ui/command_line/exceptions/unknown_command'
require 'ronin/ui/console'
require 'ronin/version'

module Ronin
  module UI
    module CommandLine
      #
      # Returns the commands registered with the command-line utility.
      #
      def CommandLine.commands
        @@ronin_commands ||= []
      end

      #
      # Returns the Hash of the Command names and their Command objects
      # registered with the command-line utility.
      #
      def CommandLine.commands_by_name
        @@ronin_commands_by_name ||= {}
      end

      #
      # Returns +true+ if the a Command with the specified _name_ was
      # registered with the command-line utility.
      #
      def CommandLine.has_command?(name)
        CommandLine.commands_by_name.has_key?(name.to_s)
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

        return CommandLine.commands_by_name[name]
      end

      #
      # Prints the specified error _message_.
      #
      def CommandLine.error(message)
        STDERR.puts "ronin: #{message}"
        return false
      end

      #
      # Prints the given error _message_ and exits unseccessfully from the
      # command-line utility. If a _block_ is given, it will be called before
      # any error _message_ are printed.
      #
      def CommandLine.fail(message,&block)
        block.call(self) if block

        CommandLine.error(message)
        exit -1
      end

      #
      # Runs the command-line utility with the given _argv_ Array. If the
      # first argument is a sub-command name, the command-line utility will
      # attempt to find and execute the Command with the same name.
      #
      def CommandLine.run(*argv)
        begin
          if (argv.empty? || argv[0][0..0]=='-')
            DefaultCommand.run(*argv)
          else
            cmd = argv.first
            argv = argv[1..-1]

            if CommandLine.has_command?(cmd)
              begin
                CommandLine.commands_by_name[cmd].run(*argv)
              rescue => excp
                STDERR.puts excp
                exit -1
              end
            else
              CommandLine.fail("unknown command #{cmd.dump}")
            end
          end
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption => e
          CommandLine.fail(e)
        end

        return true
      end
    end
  end
end
