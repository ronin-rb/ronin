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
require 'ronin/extensions/file'

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

    # The target the file was recovered from
    belongs_to :target, :unique => :target_remote_path

    # Tracks when the remote file was first recovered
    timestamps :created_at

    # Tags
    has_tags_on :tags

    #
    # The local path for the remote file.
    #
    # @return [String, nil]
    #   The local path within the `~/.ronin/campaigns` directory.
    #
    # @since 1.0.0
    #
    def local_path
      if self.target
        escaped_path = File.escape_path(self.remote_path)
        return File.join(self.target.directory,escaped_path)
      end
    end

    #
    # Determines whether the remote file has been downloaded yet.
    #
    # @return [Boolean]
    #   Specifies whether the remote file was downloaded.
    #
    # @since 1.0.0
    #
    def downloaded?
      !(File.exists?(local_path))
    end

    #
    # Opens the downloaded remote file for reading.
    #
    # @yield [file]
    #   The opened file will be passed to the given block.
    #
    # @yieldparam [File] file
    #   The opened file.
    #
    # @return [File, nil]
    #   If no block is given, the opened file will be returned.
    #
    # @since 1.0.0
    #
    def open(&block)
      File.open(local_path,'rb',&block)
    end

    #
    # Opens a local file for saving the contents of the remote file.
    #
    # @yield [file]
    #   The opened file will be passed to the given block.
    #
    # @yieldparam [File] file
    #   The opened file.
    #
    # @return [File, nil]
    #   If no block is given, the opened file will be returned.
    #
    def download!(&block)
      File.open(local_path,'wb',&block)
    end

  end
end
