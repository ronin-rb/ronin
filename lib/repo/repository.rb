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
require 'repo/fileaccess'
require 'repo/category'
require 'repo/exceptions/categorynotfound'

module Ronin
  module Repo
    class Repository

      include FileAccess

      include REXML

      # Name of the repository
      attr_reader :name

      # Type of repository
      attr_reader :type

      # Local path to the repository
      attr_reader :path

      # URL of the repository source
      attr_reader :url

      # Author of the repository
      attr_reader :author

      # Author biography
      attr_reader :author_biography

      # Email of author
      attr_reader :author_email

      # URL for author
      attr_reader :author_url

      # Description
      attr_reader :description

      # Cateogires
      attr_reader :categories

      def initialize(type,path,url)
	@name = File.basename(path)
	@type = type
	@path = path
	@url = url
	@categories = []

	Dir.foreach(@path) do |file|
	  if (File.directory?(file) && file!='.' && file!='..' && file!=Category::CONTROL_DIR)
	    @categories << file
	  end
	end

	if has_file?('metadata.xml')
	  metadata = Document.new(find_file('metadata.xml'))
	  metadata.elements.each('/metadata/author') do |element|
	    unless element.has_attribute('name')
	      raise "Repository author metadata must atleast give the author name", caller
	    end

	    @author = element.attribute('name')
	    element.each_elements_with_text('biography',1) { |bio| @author_biography = bio.get_text }
	    element.each_elements_with_text('email',1) { |email| @author_email = email.get_text }
	    element.each_elements_with_text('url',1) { |url| @author_url = url.get_text }
	  end

	  metadata.elements.each('/metadata/description') do |desc|
	    @description = desc.get_text
	  end
	end
      end

      def has_category?(category)
	@categories.include?(category)
      end

      def to_s
	@name
      end

    end
  end
end
