#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/platform/object_cache'
require 'ronin/platform/maintainer'
require 'ronin/platform/extension'
require 'ronin/ui/output/helpers'

require 'static_paths'
require 'repertoire'
require 'nokogiri'

module Ronin
  module Platform
    class Overlay

      include StaticPaths
      include Repertoire
      include UI::Output::Helpers

      # Overlay Implementation Version
      VERSION = 1

      # A list of compatible Overlay Implementation Versions
      COMPATIBLE_VERSIONS = [1]

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

      # The format version of the overlay
      attr_reader :version

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

      # The lib directory
      attr_reader :lib_dir

      # The cache directory
      attr_reader :cache_dir

      # The exts directory
      attr_reader :exts_dir

      # Repository of the overlay
      attr_reader :repository

      #
      # Creates a new Overlay object.
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

        @lib_dir = File.join(@path,LIB_DIR)
        @static_dir = File.join(@path,STATIC_DIR)
        @cache_dir = File.join(@path,CACHE_DIR)
        @exts_dir = File.join(@path,EXTS_DIR)

        @uri = uri
        @repository = Repository.new(@path,Media.types[media])
        @activated = false

        initialize_metadata()

        block.call(self) if block
      end

      #
      # Determines if the given Overlay Implementation Version is
      # compatible with the current implementation of {Overlay}.
      #
      # @param [Integer] version
      #   The version to check for compatibility.
      #
      # @return [Boolean]
      #   Specifies whether the given version is supported by {Overlay}.
      #
      def Overlay.compatible?(version)
        COMPATIBLE_VERSIONS.each do |compat|
          return true if compat === version
        end

        return false
      end

      #
      # Determines if the overlay's implementation version is compatible
      # with the current implementation of {Overlay}.
      #
      # @return [Boolean]
      #   Specifies whether the overlay is still compatible with the
      #   {Overlay}.
      #
      # @see Overlay.compatible?
      #
      def compatible?
        Overlay.compatible?(@version)
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
        Dir[File.join(@exts_dir,'*.rb')]
      end

      #
      # @return [Array]
      #   The names of all extensions within the overlay.
      #
      def extensions
        extension_paths.map { |dir| File.basename(dir).gsub(/\.rb$/,'') }
      end

      #
      # Searches for the extension with the specified name within the
      # overlay.
      #
      # @param [String, Symbol] name
      #   The name of the extension to search for.
      #
      # @return [Boolean]
      #   Specifies whether the overlay contains the extension with the
      #   specified name.
      #
      def has_extension?(name)
        extensions.include?(name.to_s)
      end

      #
      # Determines if the overlay has been activated.
      #
      # @return [Boolean]
      #   Specifies whether the overlay has been activated.
      #
      def activated?
        @activated == true
      end

      #
      # Activates the overlay by adding the {lib_dir} to the +$LOAD_PATH+
      # global variable.
      #
      def activate!
        # add the static/ directory
        static_dir(@static_dir) if File.directory?(@static_dir)

        if File.directory?(@lib_dir)
          $LOAD_PATH << @lib_dir unless $LOAD_PATH.include?(@lib_dir)
        end

        # load the lib/init.rb file
        init_path = File.join(@path,LIB_DIR,INIT_FILE)
        load init_path if File.file?(init_path)

        @activated = true
        return true
      end

      #
      # Deactivates the overlay by removing the {lib_dir} from the
      # +$LOAD_PATH+ global variable.
      #
      def deactivate!
        unregister_static_paths

        $LOAD_PATH.delete(@lib_dir)

        @activated = false
        return true
      end

      #
      # Updates the overlay, reloads it's metadata and syncs the
      # ObjectCache.
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
        # de-activate the overlay
        deactivate!

        # only update if we have a URI and a media type
        if (@uri && @media)
          @repository.update(@uri)
        end

        # re-initialize the metadata
        initialize_metadata()

        # re-activate the overlay
        activate!

        # sync the object cache
        ObjectCache.sync(cache_dir)

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
      # overlay.
      #
      def initialize_metadata()
        metadata_path = File.join(@path,METADATA_FILE)

        # set to default values
        @version = nil

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

          if (version_attr = overlay.attributes['version'])
            @version = version_attr.inner_text.strip.to_i
          else
            print_error "Overlay #{@name.dump} does not specify an Overlay Version attribute in \"ronin.xml\""
          end

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

        if (@version && !(compatible?))
          print_error "Overlay #{@name.dump} is not compatible with the current Overlay implementation"
        end

        return self
      end

    end
  end
end
