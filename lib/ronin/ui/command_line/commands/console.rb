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
require 'ronin/ui/verbose'
require 'ronin/ui/console'
require 'ronin/database'

module Ronin
  module UI
    module CommandLine
      class ConsoleCommand < Command

        def define_options(opts)
          opts.usage = '<command> [options]'
          opts.options do
            opts.on('-d','--database URI','The URI for the Database') do |uri|
              Database.config = uri.to_s
            end

            opts.on('-r','--require LIB','Require the specified library or path') do |lib|
              Console.auto_load << lib.to_s
            end

            opts.on('-v','--verbose','Enables verbose output') do
              UI::Verbose.enable!
            end

            opts.on('-V','--version','Print version information and exit') do
              success do
                puts "Ronin #{Ronin::VERSION}"
              end
            end
          end

          opts.summary %{
            Ronin is a Ruby development platform designed for information security
            and data exploration tasks.
          }
        end

        def arguments(*args)
          Console.start
        end

      end
    end
  end
end
