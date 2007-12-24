#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/author'

require 'rexml/document'
require 'open-uri'
require 'uri'

module Ronin
  module Repo
    class RepositoryMetadata

      # URI of the metadata XML document
      attr_reader :uri

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

      # Metadata URIs of dependencies
      attr_reader :deps

      # Ruby-gems required by the repositories contents
      attr_reader :gems

      def initialize(uri)
        @uri = uri
        @name = ""
        @src = ""
        @type = :local
        @authors = []
        @license = ""
        @description = ""
        @deps = {}
        @gems = []

        load_metadata
      end

      def load_metadata
        metadata = REXML::Document.new(open(@uri))

        @deps.clear
        @gems.clear

        @authors = Author.parse_xml(metadata,'/ronin/repository/contributors/author')

        metadata.elements.each('/ronin/repository') do |repo|
          @name = repo.attribute('name').to_s

          repo.each_element('type') { |type| @type = (type.get_text.to_s.downcase).to_sym }
          repo.each_element('src') { |src| @src = URI.parse(src.get_text.to_s) }

          repo.each_element('license') { |license| @license = license.get_text.to_s }
          repo.each_element('description') { |desc| @description = desc.get_text.to_s }

          repo.each_element('dependency') do |dep|
            @deps[dep.attribute('name').to_s] = URI.parse(dep.get_text.to_s)
          end

          repo.each_element('gem') do |gem|
            @gems << gem.get_text.to_s
          end
        end

        return self
      end

      def download(path)
        download_cmd = lambda { |cmd,*args|
          args = args.map { |arg| arg.to_s }

          unless system(cmd.to_s,*args)
            raise("failed to download repository '#{self}'",caller)
          end
        }

        case @type
        when :svn then
          download_cmd.call('svn','checkout',@src,path)
        when :cvs then
          download_cmd.call('cvs','checkout',@src,path)
        when :rsync then
          download_cmd.call('rsync','-av','--progress',@src,path)
        end

        return Repository.install(path)
      end

      def to_s
        @name.to_s
      end

    end
  end
end
