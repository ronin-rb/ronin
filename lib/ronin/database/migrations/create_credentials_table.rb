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

require 'ronin/database/migrations/create_user_names_table'
require 'ronin/database/migrations/create_open_ports_table'
require 'ronin/database/migrations/create_urls_table'
require 'ronin/database/migrations/migrations'

module Ronin
  module Database
    module Migrations
      migration(
        :create_credentials_table,
        :needs => [
          :create_user_names_table,
          :create_open_ports_table,
          :create_urls_table
        ]
      ) do
        up do
          create_table :ronin_credentials do
            column :id, Integer, :serial => true
            column :user_name_id, Integer, :key => true
            column :password, String

            column :open_port_id, Integer
            column :url_id, Integer
          end
        end

        down do
          drop_table :ronin_credentials
        end
      end
    end
  end
end
