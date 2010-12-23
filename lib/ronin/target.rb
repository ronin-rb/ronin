#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/campaign'
require 'ronin/address'
require 'ronin/remote_file'
require 'ronin/model'

module Ronin
  class Target

    include Model

    # Primary key of the target
    property :id, Serial

    # The campaign the target belongs to
    belongs_to :campaign

    # The host being targeted
    belongs_to :address

    # The organization that is being targeted
    has 1, :organization, :through => :address

    # The remote files recovered from the target
    has 0..n, :remote_files

    #
    # The directory to store files related to the target.
    #
    # @return [String]
    #   The path to the directory.
    #
    # @since 1.0.0
    #
    def directory
      if self.campaign
        File.join(self.campaign.directory,self.address.address)
      end
    end

  end
end
