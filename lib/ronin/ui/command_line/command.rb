#
# Ronin - A Ruby platform for exploit development and security research.
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

require 'ronin/ui/output'
require 'ronin/version'

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
        map '-V' => :version

        def self.start(arguments=ARGV,config={})
          unless map[arguments.first.to_s]
            arguments = [default_task] + arguments
          end

          super(arguments,config)
        end

        no_tasks do
          def invoke(task,arguments)
            UI::Output.verbose == output.verbose?
            UI::Output.quiet == output.quiet?
            UI::Output.silent == output.silent?
            UI::Output::Handler.color = (options.color? && !(options.nocolor?))

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

        desc "version", "displays the version"

        #
        # Prints the version information and exists.
        #
        def version
          puts "Ronin #{Ronin::VERSION}"
          exit
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

      end
    end
  end
end
