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

require 'ronin/ui/output'

require 'thor'
require 'extlib'

module Ronin
  module UI
    module CommandLine
      class Command < Thor

        include Thor::Actions
        include Output::Helpers

        default_task :default
        map '-h' => :help

        #
        # Creates a new Command object.
        #
        # @param [Array] arguments
        #   Command-line arguments.
        #
        # @param [Hash] options
        #   Additional command-line options.
        #
        # @param [Hash] config
        #   Additional configuration.
        #
        def initialize(arguments=[],options={},config={})
          @indent = 0

          super(arguments,options,config)
        end

        def self.start(arguments=ARGV,config={})
          unless map[arguments.first.to_s]
            arguments = [default_task] + arguments
          end

          super(arguments,config)
        end

        no_tasks do
          def invoke(task,arguments)
            UI::Output.verbose = options.verbose?
            UI::Output.quiet = options.quiet?
            UI::Output.silent = options.silent?

            if options.nocolor?
              UI::Output::Handler.color = false
            end

            super(task,arguments)
          end
        end

        desc "command [ARGS...]", "default task to run"
        method_option :verbose, :type => :boolean, :default => false, :aliases => '-v'
        method_option :quiet, :type => :boolean, :default => true, :aliases => '-q'
        method_option :silent, :type => :boolean, :default => true, :aliases => '-Q'
        method_option :color, :type => :boolean, :default => true
        method_option :nocolor, :type => :boolean, :default => false

        #
        # Default method to call after the options have been parsed.
        #
        def default(*arguments)
        end

        desc "help", "displays the help for the command"

        #
        # Prints the help information for the command and exists.
        #
        def help
          self.class.help(
            shell, 
            self.class.default_task,
            :short => false,
            :ident => 2,
            :namespace => false
          )
        end

        protected

        #
        # Returns the name of the command.
        #
        def name
          self.class.name.split('::').last.snake_case
        end

        #
        # Increases the indentation out output temporarily.
        #
        # @param [Integer] n
        #   The number of spaces to increase the indentation by.
        #
        # @yield []
        #   The block will be called after the indentation has been
        #   increased. After the block has returned, the indentation will
        #   be returned to normal.
        #
        # @return [nil]
        #
        def indent(n=2,&block)
          @indent += n

          block.call()

          @indent -= n
          return nil
        end

        #
        # Print the given messages with indentation.
        #
        # @param [Array] messages
        #   The messages to print, one per-line.
        #
        def puts(*messages)
          super(*(messages.map { |mesg| (' ' * @indent) + mesg.to_s }))
        end

        #
        # Prints a given title.
        #
        # @param [String] title
        #   The title to print.
        #
        def print_title(title)
          puts "[ #{title} ]"
        end

        #
        # Prints a given Array.
        #
        # @param [Array] array 
        #   The Array to print.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :title
        #   The optional title to print before the contents of the Array.
        #
        # @return [nil]
        #
        def print_array(array,options={})
          print_title(options[:title]) if options[:title]

          indent do
            array.each { |value| puts value }
          end

          puts "\n" if options[:title]
          return nil
        end

        #
        # Prints a given Hash.
        #
        # @param [Hash] hash
        #   The Hash to print.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :title
        #   The optional title to print before the contents of the Hash.
        #
        # @return [nil]
        #
        def print_hash(hash,options={})
          align = hash.keys.map { |name|
            name.to_s.length
          }.max

          print_title(options[:title]) if options[:title]

          indent do
            hash.each do |name,value|
              name = "#{name}:".ljust(align)
              puts "#{name}\t#{value}"
            end
          end

          puts "\n" if options[:title]
          return nil
        end

      end
    end
  end
end
