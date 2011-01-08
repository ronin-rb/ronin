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

require 'ronin/database/migrations/create_url_schemes_table'
require 'ronin/database/migrations/create_url_query_params_table'
require 'ronin/database/migrations/create_addresses_table'
require 'ronin/database/migrations/create_ports_table'
require 'ronin/database/migrations/create_taggings_table'
require 'ronin/database/migrations/migrations'

module Ronin
  module Database
    module Migrations
      migration(
        :create_urls_table,
        :needs => [
          :create_url_schemes_table,
          :create_url_query_params_table,
          :create_addresses_table,
          :create_ports_table,
          :create_taggings_table
        ]
      ) do
        up do
          create_table :ronin_urls do
            column :id, Integer, :serial => true
            column :scheme_id, Integer, :not_null => true
            column :host_name_id, Integer, :not_null => true
            column :port_id, Integer
            column :path, String
            column :fragment, String
            column :last_scanned_at, Time
            column :created_at, Time, :not_null => true
            column :frozen_tag_list, Text
          end

          create_index :ronin_urls, :scheme_id,
                                    :host_name_id,
                                    :port_id,
                                    :path,
                                    :fragment,
                                    :name => :unique_index_ronin_urls,
                                    :unique => true
        end

        down do
          drop_table :ronin_urls
        end
      end
    end
  end
end
