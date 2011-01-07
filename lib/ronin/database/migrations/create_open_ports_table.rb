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

require 'ronin/database/migrations/create_addresses_table'
require 'ronin/database/migrations/create_ports_table'
require 'ronin/database/migrations/create_taggings_table'
require 'ronin/database/migrations/migrations'

module Ronin
  module Database
    module Migrations
      migration(
        :create_open_ports_table,
        :needs => [
          :create_addresses_table,
          :create_ports_table,
          :create_taggings_table
        ]
      ) do
        up do
          create_table :ronin_open_ports do
            column :id, Integer, :serial => true
            column :ip_address_id, Integer, :not_null => true
            column :port_id, Integer, :not_null => true
            column :service_id, Integer
            column :last_scanned_at, Time
            column :created_at, Time, :not_null => true
            column :frozen_tag_list, Text
          end

          create_index :ronin_open_ports,
                       :ip_address_id, :port_id, :service_id,
                       :name => :unique_index_ronin_open_ports,
                       :unique => true
        end

        down do
          drop_table :ronin_open_ports
        end
      end
    end
  end
end
