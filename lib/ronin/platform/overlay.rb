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
require 'ronin/platform/maintainer'
require 'ronin/platform/object_cache'
require 'ronin/platform/extension'
require 'ronin/ui/output/helpers'
require 'ronin/model/has_license'
require 'ronin/model'

require 'static_paths'
require 'pullr/local_repository'
require 'nokogiri'

module Ronin
  module Platform
    class Overlay

      include Model
      include Model::HasLicense
      include StaticPaths
      include UI::Output::Helpers

      # Overlay Implementation Version
      VERSION = 2

      # A list of compatible Overlay Implementation Versions
      COMPATIBLE_VERSIONS = [1,2]

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

      # The primary key of the overlay
      property :id, Serial

      # Local path to the overlay
      property :path, String

      # The SCM used by the overlay
      property :scm, String

      # The format version of the overlay
      property :version, Integer

      # Name of the overlay
      property :name, String

      # URI that the overlay was installed from
      property :uri, String

      # Title of the overlay
      property :title, Text

      # Source URI of the overlay
      property :source, String

      # Source View URI of the overlay
      property :source_view, String

      # Website URI for the overlay
      property :website, String

      # Description
      property :description, Text

      # Maintainers of the overlay
      has 0..n, :maintainers

      # Ruby Gems required by the overlay
      attr_reader :gems

      # The lib directory
      attr_reader :lib_dir

      # The static directory
      attr_reader :static_dir

      # The cache directory
      attr_reader :cache_dir

      # The exts directory
      attr_reader :exts_dir

      #
      # Creates a new Overlay object.
      #
      # @param [String] path
      #   The path to the overlay.
      #
      # @param [Symbol] scm
      #   The SCM used by the overlay. Can be either `:git`, `:mercurial`,
      #   `:sub_version` or `:rsync`.
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
      def initialize(path,scm=nil,uri=nil,&block)
        path = File.expand_path(path)

        super(
          :path => path,
          :scm => scm,
          :name => File.basename(path),
          :uri => uri
        )

        @lib_dir = File.join(path,LIB_DIR)
        @static_dir = File.join(path,STATIC_DIR)
        @cache_dir = File.join(path,CACHE_DIR)
        @exts_dir = File.join(path,EXTS_DIR)

        @repository = begin
                        Pullr::LocalRepository.new(
                          :path => @path,
                          :scm => scm
                        )
                      rescue Pullr::AmbigiousRepository
                        nil
                      end

        @activated = false

        initialize_metadata()

        block.call(self) if block
      end

      #
      # Determines if the overlay's implementation version is compatible
      # with the current implementation of {Overlay}.
      #
      # @return [Boolean]
      #   Specifies whether the overlay is still compatible with the
      #   {Platform}.
      #
      def compatible?
        COMPATIBLE_VERSIONS.each do |compat|
          return true if compat === self.version
        end

        return false
      end

      #
      # @return [Symbol]
      #   The SCM used by the overlay.
      #
      def scm
        @repository.scm
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
      # Activates the overlay by adding the {#lib_dir} to the `$LOAD_PATH`
      # global variable.
      #
      def activate!
        # add the static/ directory
        register_static_dir(@static_dir) if File.directory?(@static_dir)

        if File.directory?(@lib_dir)
          $LOAD_PATH << @lib_dir unless $LOAD_PATH.include?(@lib_dir)
        end

        # load the lib/init.rb file
        init_path = File.join(self.path,LIB_DIR,INIT_FILE)
        load init_path if File.file?(init_path)

        @activated = true
        return true
      end

      #
      # Deactivates the overlay by removing the {#lib_dir} from the
      # `$LOAD_PATH` global variable.
      #
      def deactivate!
        unregister_static_dirs!

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

        # only update if we have a repository
        @repository.update(self.uri) if @repository

        # re-initialize the metadata
        initialize_metadata()

        # and save any changes to the database
        self.save

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
        FileUtils.rm_rf(@repository.path) if @repository

        self.destroy

        block.call(self) if block
        return self
      end

      #
      # @return [String]
      #   The name of the overlay.
      #
      def to_s
        self.name.to_s
      end

      protected

      #
      # Loads the overlay metadata from the METADATA_FILE within the
      # overlay.
      #
      def initialize_metadata()
        metadata_path = File.join(self.path,METADATA_FILE)

        # set to default values
        self.version = nil

        self.title = @name
        self.description = nil
        self.license = nil

        self.source = self.uri
        self.source_view = self.source
        self.website = self.source_view
        self.maintainers.clear

        @gems = []

        if File.file?(metadata_path)
          doc = Nokogiri::XML(open(metadata_path))
          overlay = doc.at('/ronin-overlay')

          if (version_attr = overlay.attributes['version'])
            self.version = version_attr.inner_text.strip.to_i
          else
            print_error "Overlay #{self.name.dump} does not specify an Overlay Version attribute in \"ronin.xml\""
          end

          if (title_tag = overlay.at('title'))
            self.title = title_tag.inner_text.strip
          end

          if (description_tag = overlay.at('description'))
            self.description = description_tag.inner_text.strip
          end

          if (license_attr = overlay.attributes['license'])
            name = license_attr.inner_text.strip

            self.license = License.predefined_resource(name)
          end

          if (source_tag = overlay.at('source'))
            self.source = source_tag.inner_text.strip
          end

          if (source_view_tag = overlay.at('source-view'))
            self.source_view = source_view_tag.inner_text.strip
          end

          if (website_tag = overlay.at('website'))
            self.website = website_tag.inner_text.strip
          end

          overlay.search('maintainers/maintainer').each do |maintainer|
            if (name = maintainer.at('name'))
              name = name.inner_text.strip
            end

            if (email = maintainer.at('email'))
              email = email.inner_text.strip
            end

            self.maintainers << Maintainer.first_or_new(
              :name => name,
              :email => email
            )
          end

          overlay.search('dependencies/gem').each do |gem|
            @gems << gem.inner_text.strip
          end
        end

        if (self.version && !(compatible?))
          print_error "Overlay #{self.name.dump} is not compatible with the current Overlay implementation"
        end

        return self
      end

    end
  end
end
