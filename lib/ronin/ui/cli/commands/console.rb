#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/ui/cli/command'
require 'ronin/ui/output'
require 'ronin/ui/console'
require 'ronin/database'
require 'ronin/version'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin console` command.
        #
        class Console < Command

          desc 'start the Ronin Console'
          class_option :database, :type => :string, :aliases => '-D'
          class_option :require, :type => :array,
                                 :default => [],
                                 :aliases => '-r',
                                 :banner => 'PATH'
          class_option :backtrace, :type => :boolean
          class_option :verbose, :type => :boolean, :aliases => '-v'
          class_option :version, :type => :boolean, :aliases => '-V'

          #
          # Starts the Ronin Console.
          #
          def execute
            if options.version?
              puts "ronin #{Ronin::VERSION}"
              return
            end

            UI::Console.color = false if options.nocolor?
            UI::Console.short_errors = false if options.backtrace?

            options[:require].each do |path|
              UI::Console.auto_load << path
            end

            if options[:database]
              Database.repositories[:default] = options[:database]
            end

            UI::Console.start
          end

        end
      end
    end
  end
end
