#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/repo/extension_context'
require 'ronin/repo/exceptions/extension_not_found'
require 'ronin/repo/config'
require 'ronin/repo/cache'

require 'repertoire'

module Ronin
  module Repo
    class Repository

      # Repository metadata XML file name
      METADATA_FILE = 'metadata.xml'

      # Local path to the repository
      attr_reader :path

      # Name of the repository
      attr_reader :name

      # Source URI of the repository source
      attr_reader :uri

      # Authors of the repository
      attr_reader :authors

      # License that the repository contents is under
      attr_reader :license

      # Description
      attr_reader :description

      def initialize(type,path,uri)
        @type = type
        @path = File.expand_path(path)
        @uri = uri

        @name = ''
        @authors = []
        @license = nil
        @description = ''

        load_metadata
      end

      #
      # Load the Repository Cache from the given _path_. If a _block_ is
      # given it will be passed the loaded Repository Cache.
      #
      #   Repository.load_cache # => Cache
      #
      #   Repository.load_cache('/custom/cache') # => Cache
      #
      def Repository.load_cache(path=Config::REPOS_CACHE_PATH,&block)
        @@cache = Cache.new(path,&block)
      end

      #
      # Returns the current Repository Cache, or loads the default Cache
      # if not already loaded.
      #
      def Repository.cache
        @@cache || load_cache
      end

      #
      # Installs the Repository specified by _options_ into the
      # <tt>Config::REPOS_DIR</tt>. If a _block_ is given, it will be
      # passed the newly created Repository after it has been added to
      # the Repository cache.
      #
      # _options_ must contain the following key:
      # <tt>:uri</tt>:: The URI of the Repository.
      #
      # _options_ may contain the following key:
      # <tt>:type</tt>:: The type of the Repository.
      #
      def Repository.install(options={},&block)
        Repertoire.checkout(:type => options[:type], :uri => options[:uri], :into => Config::REPOS_DIR) do |type,uri,path|
          return Repository.add(type,path,uri,&block)
        end
      end

      #
      # Adds the Repository specified by _type_, _path_ and _uri_ to the
      # Repository cache. If a _block is given, it will be passed the
      # newly created Repository after it has been added to the cache.
      #
      def Repository.add(type,path,uri,&block)
        Repository.new(type,path,uri).add(&block)
      end

      #
      # Adds the repository to the repository cache. If a _block is given,
      # it will be passed the newly created Repository after it has been
      # added to the cache.
      #
      def add(&block)
        Repository.cache.add(self)

        block.call(self) if block
        return self
      end

      #
      # Updates the repository and reloads it's metadata. If a _block_
      # is given it will be called after the repository has been updated.
      #
      def update(&block)
        Repertoire.update(:type => @type, :path => @path, :uri => @uri) do
          load_metadata

          block.call(self) if block
        end

        return self
      end

      #
      # Removes the repository from the repository cache. If a _block_ is
      # given, it will be passed the repository after it has been removed.
      #
      def remove(&block)
        Repository.cache.remove(self)

        block.call(self) if block
        return self
      end

      #
      # Deletes the repository then removes it from the repository cache.
      # If a _block_ is given, it will be passed the repository after it
      # has been uninstalled.
      #
      def uninstall(&block)
        Repertoire.delete(@path) do
          return remove(&block)
        end
      end

      def extension_paths
        Dir[File.join(@path,'*',File::SEPARATOR)]
      end

      def extensions
        extension_paths.map { |dir| File.basename(dir) }
      end

      def has_extension?(name)
        extensions.include?(name.to_s)
      end

      def extension_context(name,extension=nil)
        name = name.to_s

        unless has_extension?(name)
          raise(ExtensionNotfound,"repository #{to_s.dump} does not contain the extension #{name.dump}",caller)
        end

        return ExtensionContext.load_context_from(File.join(@path,name))
      end

      #
      # Returns the +name+ of the Repository.
      #
      def to_s
        @name.to_s
      end

      protected

      #
      # Loads the repository metadata from the METADATA_FILE within the
      # repository +path+.
      #
      def load_metadata
        metadata = REXML::Document.new(open(File.join(@path,METADATA_FILE)))

        @authors = Author.from_xml(metadata,'/ronin/repository/contributors/author')

        metadata.elements.each('/ronin/repository') do |repo|
          @name = repo.attribute('name').to_s

          repo.each_element('license') { |license| @license = license.get_text.to_s }
          repo.each_element('description') { |desc| @description = desc.get_text.to_s }
        end

        return self
      end

    end
  end
end
