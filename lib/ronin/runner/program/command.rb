#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/extensions/meta'
require 'ronin/runner/program/exceptions/command_not_implemented'

module Ronin
  module Runner
    module Program
      class Command

        # Formal name of the command
        attr_reader :name

        # Short-hand names of the command
        attr_reader :short_names

        #
        # Creates a new Command object with the specified _name_ and the
        # given _short_names_. If a _block_ is specified, it will be
        # passed command-line arguments when the command is ran.
        #
        def initialize(name,*short_names,&block)
          @name = name
          @short_names = short_names

          @options = nil
          @arguments_block = nil

          instance_eval(&block)
        end

        def options(usage,&block)
          @options = Options.command('ronin',@name,usage,&block)
          return self
        end

        def arguments(&block)
          @arguments_block = block
          return self
        end

        #
        # Runs the command with the given _argv_.
        #
        def run(*argv)
          if @options
            if @arguments_block
              @options.parse(argv,&(@arguments_block))
            else
              @options.parse(argv)
            end
          end
          return self
        end

        #
        # Prints the help information for the command.
        #
        def help
          @options.help if @options
          return self
        end

        #
        # Returns the String form of the command.
        #
        #   cmd = Command.new('add')
        #   cmd.to_s # => "add"
        #
        #   cmd = Command.new('list','ls')
        #   cmd.to_s # => "list ls"
        #
        def to_s
          unless @short_names.empty?
            return "#{@name} #{@short_names.join(', ')}"
          else
            return @name.to_s
          end
        end

      end
    end
  end
end
