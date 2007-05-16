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

require 'rexml/document'
require 'open-uri'
require 'uri'

module Ronin
  module Repo
    class RepositoryMetadata

      include REXML

      # Name of the repository
      attr_reader :name

      # Source URI of the repository source
      attr_reader :src

      # Type of repository
      attr_reader :type

      # Authors of the repository
      attr_reader :authors

      # License that the repository contents is under
      attr_reader :license

      # Description
      attr_reader :description

      # Cateogires provided
      attr_reader :categories

      # Metadata URIs of dependencies
      attr_reader :deps

      # Ruby-gems required by the repositories contents
      attr_reader :gems

      def initialize(metadata_uri,&block)
	metadata = Document.new(open(metadata_uri))

	@description = ""
	@categories = []
	@deps = {}
	@gems = []
	@authors = Author.parse(metadata,'/ronin/repository/author')

	metadata.elements.each('/ronin/repository') do |repo|
	  repo.each_element('type') { |type| @type = type.get_text.to_s }
	  repo.each_element('src') { |src| @src = URI.parse(src.get_text.to_s) }

	  repo.each_element('license') { |license| @license = license.get_text.to_s }
	  repo.each_element('description') { |desc| @description = desc.get_text.to_s }

	  repo.each_element('category') { |category| @categories << category.get_text.to_s }

	  repo.each_element('dependency') do |dep|
	    @deps[dep.attribute('name').to_s] = URI.parse(dep.get_text.to_s)
	  end

	  repo.each_element('gem') do |gem|
	    @gems << gem.get_text.to_s
	  end
	end

	block.call(self) if block
      end

      def download(path)
	download_cmd = lambda do |cmd,*args|
	  unless system(cmd,*args)
	    raise "failed to download repository '#{self}'", caller
	  end
	end

	case @type
	when 'svn' then
	  download_cmd.call('svn','checkout',@src.to_s,path.to_s)
	when 'cvs' then
	  download_cmd.call('cvs','checkout',@src.to_s,path.to_s)
	when 'rsync' then
	  download_cmd.call('rsync','-av','--progress',@src.to_s,path.to_s)
	end

	return Repository.new(path) { |new_repo| new_repo.install }
      end

      def to_s
	@name
      end

    end
  end
end
