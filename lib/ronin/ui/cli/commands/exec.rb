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

require 'ronin/ui/output/helpers'
require 'ronin/repository'
require 'ronin/database'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin exec` command.
        #
        class Exec

          include Output::Helpers

          #
          # Initializes the `exec` command.
          #
          # @param [String] script
          #   The name or path of the script to run.
          #
          # @param [Array<String>] arguments
          #   The arguments to the script with.
          #
          # @since 1.0.0
          #
          def initialize(script,arguments=[])
            @script = script
            @arguments = arguments
          end

          #
          # Runs the `exec` command.
          #
          # @param [Array<String>] argv
          #   The arguments to run the `exec` command with.
          #
          def self.start(argv=ARGV)
            case argv[0]
            when '-h', '--help', nil
              puts "Usage:\n  ronin-exec SCRIPT [ARGS...]\n\n"
              puts "Runs a script from a Ronin Repository"
              return false
            end

            self.new(argv[0],argv[1..-1]).execute
          end

          #
          # Executes the `exec` command.
          #
          # @since 1.0.0
          #
          def execute
            if File.file?(@script)
              require 'ronin'

              setup_argv { load File.expand_path(@script) }
              return true
            end

            Database.setup

            Repository.each do |repo|
              path = repo.path.join(Repository::BIN_DIR,@script)

              if path.file?
                require 'ronin'

                repo.activate!

                setup_argv { load path }
                return true
              end
            end

            print_error "Could not find the script #{@script.dump}."
            return false
          end

          protected

          #
          # Temporarily populates the `ARGV` constant.
          #
          # @since 1.0.0
          #
          def setup_argv
            original_argv = ARGV.dup
            ARGV.clear
            @arguments.each { |arg| ARGV << arg }

            result = yield

            ARGV.clear
            original_argv.each { |arg| ARGV << arg }
            return result
          end

        end
      end
    end
  end
end
