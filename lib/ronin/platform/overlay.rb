#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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
#++
#

require 'ronin/platform/exceptions/extension_not_found'
require 'ronin/platform/maintainer'
require 'ronin/platform/extension'

require 'rexml/document'
require 'repertoire'

module Ronin
  module Platform
    class Overlay < Repertoire::Repository

      # Overlay metadata XML file name
      METADATA_FILE = 'ronin.xml'

      # Overlay lib directory
      LIB_DIR = 'lib'

      # Overlay objects directory
      OBJECTS_DIR = 'objects'

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

      # Maintainers of the overlay
      attr_reader :maintainers

      # Description
      attr_reader :description

      # The objects directory
      attr_reader :objects_dir

      #
      # Creates a new Overlay object with the specified _path_, _media_type_
      # and _uri_.
      #
      def initialize(path,media_type=nil,uri=nil,&block)
        @path = File.expand_path(path)
        @name = File.basename(@path)
        @objects_dir = File.join(@path,OBJECTS_DIR)
        @uri = uri

        super(@path,Repertoire::Media.types[media_type])

        initialize_metadata(&block)
      end

      #
      # Media type of the overlay.
      #
      def media_type
        if @media
          return @media.name
        else
          return nil
        end
      end

      #
      # Returns the paths of all extensions within the overlay.
      #
      def extension_paths
        directories.reject do |dir|
          name = File.basename(dir)

          (name == OBJECTS_DIR) || (name == LIB_DIR)
        end
      end

      #
      # Returns the names of all extensions within the overlay.
      #
      def extensions
        extension_paths.map { |dir| File.basename(dir) }
      end

      #
      # Returns +true+ if the overlay contains the extension with the
      # specified _name_, returns +false+ otherwise.
      #
      def has_extension?(name)
        name = File.basename(name.to_s)

        return false if name == OBJECTS_DIR
        return File.directory?(File.join(@path,name))
      end

      #
      # Returns the <tt>lib/</tt> directories of the extensions within
      # the overlay.
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
      # Activates the overlay by adding the lib_dirs to the
      # <tt>$LOAD_PATH</tt>.
      #
      def activate!
        lib_dirs.each do |path|
          $LOAD_PATH << path unless $LOAD_PATH.include?(path)
        end

        return true
      end

      #
      # Deactivates the overlay by removing the lib_dirs to the
      # <tt>$LOAD_PATH</tt>.
      #
      def deactive!
        paths = lib_dirs

        $LOAD_PATH.reject! { |path| paths.include?(path) }
        return true
      end

      #
      # Updates the overlay and reloads it's metadata. If a _block_
      # is given it will be called after the overlay has been updated.
      #
      def update(&block)
        if media_type
          Repertoire.update(:media => media_type, :path => @path, :uri => @uri)
        end

        return initialize_metadata(&block)
      end

      #
      # Deletes the overlay then removes it from the overlay cache.
      # If a _block_ is given, it will be passed the overlay after it
      # has been uninstalled.
      #
      def uninstall(&block)
        Repertoire.delete(@path)

        block.call(self) if block
        return self
      end

      #
      # Returns the +name+ of the Overlay.
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
      def initialize_metadata(&block)
        metadata_path = File.join(@path,METADATA_FILE)

        # set to default values
        @title = @name
        @license = nil

        @source = @uri
        @source_view = @source
        @website = @source_view

        @maintainers = []
        @description = nil

        if File.file?(metadata_path)
          doc = REXML::Document.new(open(metadata_path))
          overlay = doc.elements['/ronin-overlay']

          overlay.each_element('title[.]:first') do |title|
            @title = title.text.strip
          end

          overlay.each_element('license[.]:first') do |license|
            @license = license.text.strip
          end

          overlay.each_element('source[.]:first') do |source|
            @source = source.text.strip
          end

          overlay.each_element('source-view[.]:first') do |source_view|
            @source_view = source_view.text.strip
          end

          overlay.each_element('website[.]:first') do |website|
            @website = website.text.strip
          end

          overlay.each_element('maintainers/maintainer') do |maintainer|
            if (name = maintainer.text('name'))
              name.strip!
            end

            if (email = maintainer.text('email'))
              email.strip!
            end

            @maintainers << Maintainer.new(name,email)
          end

          overlay.each_element('description[.]:first') do |description|
            @description = description.text.strip
          end
        end

        block.call(self) if block
        return self
      end

    end
  end
end
