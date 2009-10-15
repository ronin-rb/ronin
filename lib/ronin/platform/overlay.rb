#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/platform/exceptions/extension_not_found'
require 'ronin/platform/maintainer'
require 'ronin/platform/extension'
require 'ronin/static/static'

require 'repertoire'
require 'nokogiri'

module Ronin
  module Platform
    class Overlay

      include Repertoire

      # Overlay metadata XML file name
      METADATA_FILE = 'ronin.xml'

      # Overlay lib/ directory
      LIB_DIR = 'lib'

      # The init.rb file to load from the LIB_DIR
      INIT_FILE = 'init.rb'

      # Overlay static/ directory
      STATIC_DIR = 'static'

      # Overlay cache/ directory
      CACHE_DIR = 'cache'

      # Overlay exts/ directory
      EXTS_DIR = 'exts'

      # Local path to the overlay
      attr_reader :path

      # Name of the overlay
      attr_reader :name

      # URI that the overlay was installed from
      attr_reader :uri

      # Title of the overlay
      attr_reader :title

      # License that the overlay contents is under
      attr_reader :license

      # Source URI of the overlay
      attr_reader :source

      # Source View URI of the overlay
      attr_reader :source_view

      # Website URI for the overlay
      attr_reader :website

      # Ruby Gems required by the overlay
      attr_reader :gems

      # Maintainers of the overlay
      attr_reader :maintainers

      # Description
      attr_reader :description

      # The static directory
      attr_reader :static_dir

      # The cache directory
      attr_reader :cache_dir

      # The exts directory
      attr_reader :exts_dir

      # Repository of the overlay
      attr_reader :repository

      #
      # Creates a new Overlay object with the specified _path_, _media_
      # and _uri_. If a _block_ is given it will be passed the newly
      # created Overlay object.
      #
      # @param [String] path
      #   The path to the overlay.
      #
      # @param [Symbol] media
      #   The media of the overlay. Can be either +:git+, +:hg+, +:snv+ or
      #   +:rsync+.
      #
      # @param [String, URI::HTTP, URI::HTTPS] uri
      #   The URI the overlay resides at.
      #
      # @yield [overlay]
      #   If a block is given, the overlay will be passed to it.
      #
      # @yieldparam [Overlay] overlay
      #   The newly created overlay.
      #
      def initialize(path,media=nil,uri=nil,&block)
        @path = File.expand_path(path)
        @name = File.basename(@path)
        @static_dir = File.join(@path,STATIC_DIR)
        @cache_dir = File.join(@path,CACHE_DIR)
        @exts_dir = File.join(@path,EXTS_DIR)
        @uri = uri
        @repository = Repository.new(@path,Media.types[media])

        initialize_metadata()

        block.call(self) if block
      end

      #
      # @return [Symbol]
      #   The media type of the overlay.
      #
      def media
        @repository.media_name
      end

      #
      # @return [Array]
      #   The paths of all extensions within the overlay.
      #
      def extension_paths
        Dir[File.join(@exts_dir,'*')].select do |path|
          File.directory?(path)
        end
      end

      #
      # @return [Array]
      #   The names of all extensions within the overlay.
      #
      def extensions
        extension_paths.map { |dir| File.basename(dir) }
      end

      #
      # Searches for the extension with the specified _name_ within the
      # overlay.
      #
      # @param [String, Symbol] name
      #   The name of the extension to search for.
      #
      # @return [Boolean]
      #   Specifies whether the overlay contains the extension with the
      #   specified _name_.
      #
      def has_extension?(name)
        extensions.include?(name.to_s)
      end

      #
      # @return [Array]
      #   The +lib+ directories of the overlay and the extensions within
      #   the overlay.
      #
      def lib_dirs
        dirs = []

        find_directory = lambda { |path|
          dirs << path if File.directory?(path)
        }

        find_directory.call(File.join(@path,LIB_DIR))

        extension_paths.each do |path|
          find_directory.call(File.join(path,Extension::LIB_DIR))
        end

        return dirs
      end

      #
      # Determines if the overlay has been activated.
      #
      # @return [Boolean]
      #   Specifies whether the overlay has been activated.
      #
      def activated?
        lib_dirs.any? { |path| $LOAD_PATH.include?(path) }
      end

      #
      # Activates the overlay by adding all of the lib_dirs to the
      # +$LOAD_PATH+ global variable.
      #
      def activate!
        # add the static/ directory
        Static.directory(@static_dir) if File.directory?(@static_dir)

        # add the lib/ directories
        lib_dirs.each do |path|
          $LOAD_PATH << path unless $LOAD_PATH.include?(path)
        end

        # load the lib/init.rb file
        init_path = File.join(@path,LIB_DIR,INIT_FILE)
        load init_path if File.file?(init_path)

        return true
      end

      #
      # Deactivates the overlay by removing the lib_dirs from the
      # +$LOAD_PATH+ global variable.
      #
      def deactivate!
        Static.static_dirs.reject! { |dir| dir == @static_dir }

        paths = lib_dirs
        $LOAD_PATH.reject! { |path| paths.include?(path) }
        return true
      end

      #
      # Updates the overlay and reloads it's metadata.
      #
      # @yield [overlay]
      #   If a block is given, it will be passed after the overlay has
      #   been updated.
      #
      # @yieldparam [Overlay] overlay
      #   The updated overlay.
      #
      # @return [Overlay]
      #   The updated overlay.
      #
      def update(&block)
        if (@uri && @media)
          if @repository.update(@uri)
            initialize_metadata()
          end
        end

        block.call(self) if block
        return self
      end

      #
      # Deletes the contents of the overlay.
      #
      # @yield [overlay]
      #   If a block is given, it will be passed the overlay after it's
      #   contents have been deleted.
      #
      # @yieldparam [Overlay] overlay
      #   The deleted overlay.
      #
      # @return [Overlay]
      #   The deleted overlay.
      #
      def uninstall(&block)
        @repository.delete

        block.call(self) if block
        return self
      end

      #
      # @return [String]
      #   The name of the overlay.
      #
      def to_s
        @name.to_s
      end

      protected

      #
      # Loads the overlay metadata from the METADATA_FILE within the
      # overlay +path+. If a _block_ is given, it will be passed the
      # overlay after the metadata has been loaded.
      #
      def initialize_metadata()
        metadata_path = File.join(@path,METADATA_FILE)

        # set to default values
        @title = @name
        @license = nil

        @source = @uri
        @source_view = @source
        @website = @source_view

        @gems = []

        @maintainers = []
        @description = nil

        if File.file?(metadata_path)
          doc = Nokogiri::XML(open(metadata_path))
          overlay = doc.at('/ronin-overlay')

          if (title_tag = overlay.at('title'))
            @title = title_tag.inner_text.strip
          end

          if (license_tag = overlay.at('license'))
            @license = license_tag.inner_text.strip
          end

          if (source_tag = overlay.at('source'))
            @source = source_tag.inner_text.strip
          end

          if (source_view_tag = @source_view = overlay.at('source-view'))
            @source_view = source_view_tag.inner_text.strip
          end

          if (website_tag = @website = overlay.at('website'))
            @website = website_tag.inner_text.strip
          end

          overlay.search('dependencies/gem').each do |gem|
            @gems << gem.inner_text.strip
          end

          overlay.search('maintainers/maintainer').each do |maintainer|
            if (name = maintainer.at('name'))
              name = name.inner_text.strip
            end

            if (email = maintainer.at('email'))
              email = email.inner_text.strip
            end

            @maintainers << Maintainer.new(name,email)
          end

          if (description_tag = overlay.at('description'))
            @description = description_tag.inner_text.strip
          end
        end

        return self
      end

    end
  end
end
