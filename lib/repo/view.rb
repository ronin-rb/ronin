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
require 'exceptions/categorynotfound'

module Ronin
  module Repo

    # Current loading view
    $current_view = nil

    class View

      # Associated config object
      attr_reader :config

      # Name of the view-repository
      attr_reader :repo

      # Name of the view-category
      attr_reader :category

      # Loaded categories
      attr_accessor :categories

      def initialize(config,repo,category)
	@config = config
	@repo = repo
	@category = category

	@categories = []
      end

      def setup
	@categories[0].setup
      end

      def action(name)
	@categories[0].action(name)
      end

      def teardown
	@categories[0].setup
      end

      def load_category(repo=nil,name)
	@categories.each do |category|
	  return category if (category.name==name && (repo.nil? || (repo && category.repo==repo)))
	end

	return get_repository(repo).load_category(name) if repo

	@config.repos.each_data do |repo|
	  return repo.load_category(name) if repo.has_category?(name)
	end

	raise CategoryNotFound, "cannot find category '#{name}'"
      end

      def get_repository(repo)
	@config.get_repository(repo)
      end

      def to_s
	return @category unless @repo
	return @repo + File.SEPARATOR + @category
      end

    end
  end
end
