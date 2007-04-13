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

require 'repo/fileaccess'
require 'repo/category'
require 'repo/exceptions/categorynotfound'
require 'rexml/document'
require 'uri'
require 'open-uri'

module Ronin
  module Repo
    class Repository

      include FileAccess
      include REXML

      # Name of the repository
      attr_reader :name

      # Local path to the repository
      attr_reader :path

      # URL of the repository source
      attr_reader :url

      # Type of repository
      attr_reader :type

      # Author(s) of the repository
      attr_reader :authors

      # Description
      attr_reader :description

      # Repository dependencies
      attr_reader :deps

      # Cateogires
      attr_reader :categories

      def initialize(name,path)
	@name = name
	@path = path
	@authors = {}
	@deps = {}
	@categories = []

	Dir.foreach(@path) do |file|
	  if (File.directory?(file) && file!='.' && file!='..' && file!=Category::CONTROL_DIR)
	    @categories << file
	  end
	end

	if has_file?('metadata.xml')
	  metadata = Document.new(File.new(find_file('metadata.xml')))

	  metadata.elements.each('/ronin/repository/type') { |type| @type = type.get_text.to_s }
	  metadata.elements.each('/ronin/repository/src') { |src| @src = URI.parse(src.get_text.to_s) }

	  metadata.elements.each('/ronin/repository/author') do |author|
	    new_author = Author.parse_xml(author)
	    @authors[new_author.name] = new_author
	  end

	  metadata.elements.each('/ronin/repository/description') do |desc|
	    @description = desc.get_text.to_s
	  end

	  metadata.elements.each('/ronin/repository/dependency') do |dep|
	    @deps[dep.attribute('name')] = URI.parse(dep.get_text.to_s)
	  end
	end
      end

      def has_category?(category)
	@categories.include?(category)
      end

      def install(name,src,path=File.join(Config::REPOS_PATH,name))
	metadata = Document.new(open(src))

	metadata.elements.each('/ronin/repository/type') { |type| repo_type = type }
	metadata.elements.each('/ronin/repository/src') { |src| repo_src = src }

	case repo_type
	  when 'svn' then system("svn co '#{repo_src}' '#{path}'")
	  when 'cvs' then system("cvs checkout '#{repo_src}' '#{path}'")
	  when 'rsync' then system("rsync -av --progress '#{repo_src}' '#{path}'")
	end

	new_repo = Repository.new(name,path)
	config.add_registory(new_repo)
	return new_repo
      end

      def update
        case @type
          when 'svn' then system("svn up '#{@path}'")
          when 'cvs' then system("cvs update -dP '#{@path}'")
          when 'rsync' then system("rsync -av --delete-after --progress '#{@url}' '#{@path}'")
        end
      end

      def to_s
	@name
      end

    end
  end
end
