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

require 'ronin/ui/diagnostics'
require 'ronin/version'

require 'thor'
require 'extlib'

module Ronin
  module UI
    module CommandLine
      class Command < Thor

        include Thor::Actions
        include Diagnostics

        default_task :default
        map '-h' => :help
        map '-V' => :version

        desc "command [ARGS...]", "default task to run"

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

        desc "help [TASK]", "displays the help for the command"

        #
        # Prints the help information for the command and exists.
        #
        def help(task=nil)
          self.class.help(
            shell, 
            task, 
            :short => true,
            :ident => 2,
            :namespace => "ronin:#{self.name}"
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
        # If the task method cannot be found, default to calling run.
        #
        def method_missing(name,*arguments)
          default(*arguments)
        end

      end
    end
  end
end
