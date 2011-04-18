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

require 'ronin/database/migrations/create_targets_table'
require 'ronin/database/migrations/migrations'
require 'ronin/campaign'
require 'ronin/target'

module Ronin
  module Database
    module Migrations
      migration(
        :add_created_at_column_to_targets_table,
        :needs => :create_targets_table
      ) do
        up do
          modify_table :ronin_targets do
            add_column :created_at, Time
          end

          # set the updated_at column to the created_at of the Campaign
          Target.each do |target|
            target.update(:created_at => target.campaign.created_at)
          end
        end

        down do
        end
      end
    end
  end
end
