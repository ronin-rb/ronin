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
      migration(:create_countries_table) do
        up do
          create_table :ronin_countries do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :code, String, :length => 2, :not_null => true
          end

          create_index :ronin_countries, :name, :unique => true
          create_index :ronin_countries, :code, :unique => true
        end

        down do
          drop_table :ronin_countries
        end
      end
    end
  end
end
