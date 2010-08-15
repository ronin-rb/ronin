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

module Ronin
  module Database
    module Migrations
      migration(:create_host_name_ip_addresses_table, :needs => :create_addresses_table) do
        up do
          create_table :ronin_host_name_ip_addresses do
            column :host_name_id, Integer, :key => true
            column :ip_address_id, Integer, :key => true
            column :created_at, Time, :not_null => true
          end
        end

        down do
          drop_table :ronin_host_name_ip_addresses
        end
      end
    end
  end
end
