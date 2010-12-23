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

require 'ronin/target'
require 'ronin/model'

require 'dm-timestamps'
require 'dm-tags'

module Ronin
  class RemoteFile

    include Model

    # Primary key of the remote file
    property :id, Serial

    # Remote path of the file
    property :remote_path, String, :required => true,
                                   :index => true,
                                   :unique => :target_remote_path

    # Local path of the file
    property :local_path, String

    # The target the file was recovered from
    belongs_to :target, :unique => :target_remote_path

    # Tracks when the remote file was first recovered
    timestamps :created_at

    # Tags
    has_tags_on :tags

    #
    # Searches for all remote files that have been downloaded.
    #
    # @return [Array<RemoteFile>]
    #   The downloaded remote files.
    #
    # @since 1.0.0
    #
    def self.downloaded
      all(:local_path.not => nil)
    end

  end
end
