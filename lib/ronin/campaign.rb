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

require 'ronin/model'
require 'ronin/model/has_name'
require 'ronin/model/has_description'
require 'ronin/config'
require 'ronin/target'

require 'fileutils'

module Ronin
  class Campaign

    include Model
    include Model::HasName
    include Model::HasDescription

    # Primary key of the campaign
    property :id, Serial

    # The targets of the campaign
    has 0..n, :targets

    # The addresses being targeted in the campaign
    has 0..n, :addresses, :through => :targets

    # The organization the campaign covers
    has 0..n, :organizations, :through => :targets

    #
    # The file-name to use for the campaign.
    #
    # @return [String, nil]
    #   The File System safe name to use for the campaign.
    #
    # @since 1.0.0
    #
    def filename
      self.name.downcase.gsub(/[^a-z0-9]+/,'_') if self.name
    end

    #
    # The directory to store files related to the campaign.
    #
    # @return [String, nil]
    #   The path to the directory.
    #
    # @since 1.0.0
    #
    def directory
      if self.name
        path = File.join(Config::CAMPAIGNS_DIR,filename)

        FileUtils.mkdir(path) unless File.directory?(path)
        return path
      end
    end

  end
end
