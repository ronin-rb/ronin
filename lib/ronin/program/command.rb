#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/program/options'
require 'ronin/program/program'
require 'ronin/extensions/meta'

module Ronin
  module Program
    class Command

      #
      # Creates a new Command object. If a _block_ is given,
      # it will be passed newly created Command object.
      #
      def initialize(&block)
        @options = nil

        block.call(self) if block
      end

      #
      # Returns the name of the command.
      #
      def Command.command_name
        ''
      end

      #
      # Returns the short names of the command.
      #
      def Command.command_short_names
        []
      end

      #
      # Returns all the names of the command.
      #
      def self.command_names
        [self.command_name] + self.command_short_names
      end

      #
      # Creates a new command object and runs it with the
      # given _args_.
      #
      def self.run(*args)
        self.new.run(*args)
      end

      #
      # Prints the help information for the command.
      #
      def self.help
        self.new.help
      end

      #
      # Returns the name of the command.
      #
      def command_name
        self.class.command_name
      end

      #
      # Returns the short names of the command.
      #
      def command_short_names
        self.class.command_short_names
      end

      #
      # Returns all the names of the command.
      #
      def command_names
        self.class.command_names
      end

      #
      # Runs the command with the given _args_. If a _block_ is
      # given, it will be called after the specified _args_ have
      # been parsed and the command has run.
      #
      def run(*args,&block)
        arguments(*(options.parse(args)))

        @options = nil

        block.call if block
        return self
      end

      #
      # Prints the help information for the command.
      #
      def help
        options.help
        return self
      end

      #
      # Returns the String form of the command.
      #
      def to_s
        names.join(', ')
      end

      protected

      #
      # Registers the command with the specified _name_ and the given
      # _short_names_.
      #
      def self.command(name,*short_names)
        name = name.to_s
        short_names = short_names.map { |short_name| short_name.to_s }

        meta_def(:command_name) { name }
        meta_def(:command_short_names) { short_names }

        # register the command
        Program.commands << self unless Program.commands.include?(self)

        # register the command by name
        Program.commands_by_name[name] = self

        # register the command by it's short_names
        short_names.each do |short_name|
          Program.commands_by_name[short_name] = self
        end

        return self
      end

      #
      # Defines the options of the command with the specified _usage_ and
      # _block_.
      #
      def self.options(usage=nil,&block)
        class_def(:options) do
          @options ||= Options.command(:ronin,self.command_name,usage,&block)
        end

        return self
      end

      #
      # Returns the options of the command.
      #
      def options
        @options ||= Options.command(:ronin,command_name)
      end

      #
      # See Program.error.
      #
      def error(message)
        Program.error(message)
      end

      #
      # See Program.success.
      #
      def success(&block)
        Program.success(&block)
      end

      #
      # See Program.fail.
      #
      def fail(*messages,&block)
        Program.fail(*messages,&block)
      end

      #
      # Processes the additional arguments specified by _args_.
      #
      def arguments(*args)
      end

    end
  end
end
