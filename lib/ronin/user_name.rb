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

require 'ronin/model'
require 'ronin/model/has_unique_name'
require 'ronin/credential'
require 'ronin/email_address'

require 'dm-timestamps'

module Ronin
  #
  # Represents a user name that can be stored in the {Database}.
  #
  class UserName

    include Model
    include Model::HasUniqueName

    # The primary key of the user name
    property :id, Serial

    # Tracks when the user-name was created.
    timestamps :created_at

    # Any credentials belonging to the user
    has 0..n, :credentials

    # Email addresses of the user
    has 0..n, :email_addresses

  end
end
