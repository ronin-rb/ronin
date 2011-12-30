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
require 'ronin/repository'
require 'ronin/database'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-uninstall` command.
        #
        class Uninstall < Command

          summary 'Uninstalls Ronin Repositories'

          argument :repo, :type => String,
                          :description => 'Repository to uninstall'

          #
          # Sets up the install command.
          #
          def setup
            super

            Database.setup
          end

          #
          # Executes the command.
          #
          def execute
            unless repo?
              print_error "Must specify the REPO argument"
              exit -1
            end

            repository = Repository.uninstall(@repo)

            print_info "Repository #{repository} uninstalled."
          end

        end
      end
    end
  end
end
