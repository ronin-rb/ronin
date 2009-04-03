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
require 'ronin/ui/command_line/command_line'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Help < Command

          def define_options(opts)
            opts.usage = '[COMMAND]'

            opts.arguments(
              'COMMAND' => 'The command to view'
            )

            opts.summary %{
              View a list of supported commands or information on a
              specific command
            }
          end

          def arguments(*args)
            if args.length > 1
              fail('only one command maybe specified')
            end

            topic = args.first

            if topic
              begin
                CommandLine.get_command(topic).run('--help')
              rescue UnknownCommand
                fail("unknown sub-command #{topic.dump}")
              end
            else
              puts 'Available sub-commands:'

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
