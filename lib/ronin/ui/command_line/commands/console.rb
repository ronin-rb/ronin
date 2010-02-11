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

require 'ronin/ui/command_line/command'
require 'ronin/ui/output'
require 'ronin/ui/console'
require 'ronin/database'
require 'ronin/version'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Console < Command

          desc 'start the Ronin Console'
          class_option :database, :type => :string, :aliases => '-D'
          class_option :require, :type => :array, :aliases => '-r'
          class_option :verbose, :type => :boolean, :aliases => '-v'

          def execute
            if options.version?
              puts "ronin #{Ronin::VERSION}"
              return
            end

            if options[:require]
              options[:require].each do |path|
                UI::Console.auto_load << path
              end
            end

            if options[:database]
              Database.config = options[:database]
            end

            UI::Console.start
          end

        end
      end
    end
  end
end
