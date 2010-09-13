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

require 'ronin/target'
require 'ronin/model'
require 'ronin/model/has_name'
require 'ronin/model/has_description'
require 'ronin/extensions/file'
require 'ronin/config'

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

    # The host comments made during the campaign
    has 0..n, :comments, :through => :addresses

    #
    # The directory name used by the campaign.
    #
    # @return [String]
    #   The lowercase, underscore-separated and escaped directory name
    #   for the campaign.
    #
    # @since 0.4.0
    #
    def dir_name
      File.escape_name(self.name.downcase.gsub(/[\s]+/,'_'))
    end

    #
    # The directory which stores collected files for the campaign.
    #
    # @return [String]
    #   The files directory used by the campaign.
    #
    def files_dir
      File.join(Config::CAMPAIGNS_DIR,dir_name,'files')
    end

  end
end
