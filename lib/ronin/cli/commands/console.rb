#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/cli/command'
require 'ronin/core/cli/console'

module Ronin
  class CLI
    module Commands
      #
      # Starts the Ronin Console.
      #
      # ## Usage
      #
      #     ronin console [options]
      #
      # ## Options
      #
      #      -v, --[no-]verbose               Enable verbose output.
      #      -q, --[no-]quiet                 Disable verbose output.
      #      --[no-]silent                    Silence all output.
      #      -D, --database [URI]             The database to URI.
      #      -r, --require [PATH]             Ruby files to require.
      #                                       Default: []
      #          --[no-]backtrace             Enable long backtraces.
      #      -V, --[no-]version               Print the Ronin version.
      #
      class Console < Command

        option :include, short: '-I',
                         value: {
                           type: String,
                           usage: 'DIR'
                         },
                         desc: 'Directory to add to $LOAD_PATH' do |dir|
                           @include_dirs << dir
                         end

        option :require, short: '-r',
                         value: {
                           type:  String,
                           usage: 'PATH'
                         },
                         desc: 'Ruby files to require' do |path|
                           @require_paths << path
                         end

        description "Start ronin's interactive ruby console"

        man_page 'ronin-console.1'

        # The additional directories to add to `$LOAD_PATH`.
        #
        # @return [Array<String>]
        attr_reader :include_dirs

        # The additional paths to require before starting the console.
        #
        # @return [Array<String>]
        attr_reader :require_paths

        #
        # Initializes the {Console} command.
        #
        # @param [Array<String>] include_dirs
        #   Optional Array of directories to add to `$LOAD_PATH`.
        #
        # @param [Array<String>] require_paths
        #   Optional Array of paths to require before starting the console.
        #
        def initialize(include_dirs: [], require_paths: [], **kwargs)
          super(**kwargs)

          @include_dirs  = include_dirs
          @require_paths = require_paths
        end

        #
        # Starts the console.
        #
        def run(*argv)
          @include_dirs.each do |dir|
            $LOAD_PATH.unshift(dir)
          end

          @require_paths.each do |path|
            require(path)
          end

          require 'ronin'
          Core::CLI::Console.start(context: Ronin)
        end

      end
    end
  end
end
