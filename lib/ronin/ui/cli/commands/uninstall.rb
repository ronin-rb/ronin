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

          desc 'Uninstalls Ronin Repositories'
          argument :name, :type     => :string,
                          :required => true

          #
          # Executes the command.
          #
          def execute
            repository = Repository.uninstall(name)

            print_info "Repository #{repository} uninstalled."
          end

          protected

          #
          # Sets up the install command.
          #
          def setup
            super

            Database.setup
          end

        end
      end
    end
  end
end
