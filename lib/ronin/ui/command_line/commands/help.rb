#
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
#

require 'ronin/ui/command_line/command'
require 'ronin/ui/command_line/command_line'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Help < Command

          desc "help [COMMAND]", "Displays the list of available commands or prints information on a specific command"

          def default(command=nil)
            if command
              begin
                CommandLine.get_command(command).start(['--help'])
              rescue UnknownCommand
                print_error "unknown command #{command.dump}"
                exit -1
              end
            else
              puts 'Available commands:'

              CommandLine.commands.sort.each do |name|
                puts "  #{name}"
              end
            end
          end

        end
      end
    end
  end
end
