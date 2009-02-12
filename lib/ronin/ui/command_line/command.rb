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

require 'ronin/ui/command_line/options'

module Ronin
  module UI
    module CommandLine
      class Command

        # The name of the command
        attr_reader :name

        # The options for the command
        attr_reader :options

        #
        # Creates a new Command object.
        #
        def initialize(&block)
          @name = File.basename($0)

          Options.new(@name) do |opts|
            define_options(opts)

            @options = opts
          end

          block.call(self) if block
        end

        #
        # Creates a new command object and runs it with the given _args_.
        #
        def self.run(*args)
          cmd = self.new

          begin
            cmd.arguments(*(cmd.options.parse(args)))
          rescue OptionParser::MissingArgument, OptionParser::InvalidOption => e
            cmd.fail(e)
          end

          return true
        end

        #
        # Prints the help information for the command.
        #
        def self.help
          self.new.help
        end

        #
        # Prints the help information for the command.
        #
        def help
          @options.help
          return self
        end

        #
        # Returns the String form of the command.
        #
        def to_s
          @name.to_s
        end

        protected

        #
        # Prints the specified error _message_.
        #
        def error(message)
          STDERR.puts "ronin: #{@name}: #{message}"
          return false
        end

        #
        # Calls the specified _block_, then exists with the status code of 0.
        #
        def success(&block)
          block.call
          exit 0
        end

        #
        # Prints the given error _message_ and exits unseccessfully from the
        # command-line utility. If a _block_ is given, it will be called before
        # any error _message_ are printed.
        #
        def fail(message,&block)
          block.call() if block

          error(message)
          exit -1
        end

        #
        # Define the command-line options for the command.
        #
        def define_options(opts)
        end

        #
        # Processes the additional arguments specified by _args_.
        #
        def arguments(*args)
        end

      end
    end
  end
end
