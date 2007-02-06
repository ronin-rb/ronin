#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'category'

module Ronin
  module Repo

    # TODO: make this cross-platform later
    CONFIG_PATH = "/etc/ronin.conf"

    class Config

      # Hash of loaded repositories
      attr_reader :repos

      def initialize(path=CONFIG_PATH)
        @repos = Hash.new
        # TODO: parse REPOS_CONFIG and create Hash of repositories.
      end

      def get_repository(name)
        return @repos[name]
      end

      def get_category(repo_name=nil,category_name)
        if repo_name
          return @repos[repo_name].get_category(category_name)
        end

        @repos.each do |r|
          return r.get_category(category_name) if r.has_category?(category_name)
        end

        return nil
      end

    end
  end
end
