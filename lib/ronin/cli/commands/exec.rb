#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
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
require 'ronin/repos'

module Ronin
  class CLI
    module Commands
      #
      # Runs a Ruby script in the Ronin environment.
      #
      # ## Usage
      #
      #     ronin exec SCRIPT [ARGS...]
      #
      class Exec < Command

        usage 'SCRIPT [ARGS ...]'

        argument :script, desc: 'The executable file name'

        argument :args, required: false,
                        repeats: true,
                        desc: 'Additional arguments for the executable'

        man_page 'ronin-exec.1'

        #
        # Executes the `exec` command.
        #
        def run(script,*args)
        end

      end
    end
  end
end
