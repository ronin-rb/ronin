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

require 'ronin/database/migrations/migrations'
require 'ronin/database/migrations/create_authors_table'
require 'ronin/database/migrations/create_overlays_table'

module Ronin
  module Database
    module Migrations
      migration(
        :create_overlay_maintainers_table,
        :needs => [
          :create_authors_table,
          :create_overlays_table
        ]
      ) do
        up do
          create_table :ronin_overlay_maintainers do
            column :id, Integer, :serial => true
            column :author_id, Integer
            column :overlay_id, Integer
          end
        end

        down do
          drop_table :ronin_overlay_maintainers
        end
      end
    end
  end
end
