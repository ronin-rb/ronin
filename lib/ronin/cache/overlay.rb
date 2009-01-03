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

require 'ronin/cache/maintainer'
require 'ronin/cache/extension'
require 'ronin/cache/exceptions/extension_not_found'
require 'ronin/cache/overlay_cache'
require 'ronin/cache/config'

require 'rexml/document'
require 'repertoire'

module Ronin
  module Cache
    class Overlay < Repertoire::Repository

      # Overlay metadata XML file name
      METADATA_FILE = 'ronin.xml'

      # Overlay objects directory
      OBJECTS_DIR = 'objects'

      # Local path to the overlay
      attr_reader :path

      # URI that the overlay was installed from
      attr_reader :uri

      # Name of the overlay
      attr_reader :name

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

      #
      # Creates a new Overlay object with the specified _path_, _media_type_
      # and _uri_.
      #
      def initialize(path,media_type=nil,uri=nil,&block)
        @path = File.expand_path(path)
        @uri = uri

        super(@path,Repertoire::Media.types[media_type])

        initialize_metadata(&block)
      end

      #
      # Load the Overlay Cache from the given _path_. If _path is not
      # given, it will default to <tt>Config::REPOSITORY_CACHE_PATH</tt>.
      # If a _block_ is given it will be passed the loaded Overlay Cache.
      #
      #   Overlay.load_cache # => Cache
      #
      #   Overlay.load_cache('/custom/cache') # => Cache
      #
      def Overlay.load_cache(path=Config::OVERLAY_CACHE_PATH,&block)
        @@cache = OverlayCache.new(path,&block)
      end

      #
      # Returns the current OverlayCache, or loads the default Cache
      # if not already loaded.
      #
      def Overlay.cache
        @@cache ||= load_cache
      end

      #
      # Saves the overlay cache. If a _block_ is given, it will be passed
      # the overlay cache before being saved.
      #
      #   Overlay.save_cache # => OverlayCache
      #
      #   Overlay.save_cahce do |cache|
      #     puts "Saving cache #{cache}"
      #   end
      #
      def Overlay.save_cache(&block)
        Overlay.cache.save(&block)
      end

      #
      # Returns the overlay with the specified _name_ from the overlay
      # cache. If no such overlay exists, +nil+ is returned.
      #
      #   Overlay['awesome']
      #
      def Overlay.[](name)
        Overlay.cache[name]
      end

      #
      # Returns +true+ if there is a overlay with the specified _name_
      # in the overlay cache, returns +false+ otherwise.
      #
      def Overlay.exists?(name)
        Overlay.cache.has_overlay?(name)
      end

      #
      # Returns the overlay with the specified _name_ from the overlay
      # cache. If no such overlay exists in the overlay cache,
      # a OverlayNotFound exception will be raised.
      #
      def Overlay.get(name)
        Overlay.cache.get_overlay(name)
      end

      #
      # Installs the Overlay specified by _options_ into the
      # <tt>Config::REPOSITORY_DIR</tt>. If a _block_ is given, it will be
      # passed the newly created Overlay after it has been added to
      # the Overlay cache.
      #
      # _options_ must contain the following key:
      # <tt>:uri</tt>:: The URI of the Overlay.
      #
      # _options_ may contain the following key:
      # <tt>:media</tt>:: The media of the Overlay.
      #
      def Overlay.install(options={},&block)
        options = options.merge(:into => Config::REPOSITORY_DIR)

        Repertoire.checkout(options) do |path,media,uri|
          return Overlay.add(path,media,uri,&block)
        end
      end

      #
      # Adds the Overlay at the specified _path_, the given _uri_
      # and given the _uri_ to the Overlay cache. If a _block is given, it
      # will be passed the newly created Overlay after it has been added to
      # the cache.
      #
      def Overlay.add(path,media=nil,uri=nil,&block)
        Overlay.new(path,media,uri).add(&block)
      end

      #
      # Updates the overlay with the specified _name_. If there is no
      # overlay with the specified _name_ in the overlay cache
      # a OverlayNotFound exception will be raised. If a _block_ is
      # given it will be passed the updated overlay.
      #
      def Overlay.update(name,&block)
        Overlay.get(name).update(&block)
      end

      #
      # Removes the overlay with the specified _name_. If there is no
      # overlay with the specified _name_ in the overlay cache
      # a OverlayNotFound exception will be raised. If a _block_ is
      # given it will be passed the overlay before removal.
      #
      def Overlay.remove(name,&block)
        Overlay.get(name).remove(&block)
      end

      #
      # Uninstall the overlay with the specified _name_. If there is no
      # overlay with the specified _name_ in the overlay cache
      # a OverlayNotFound exception will be raised. If a _block_ is
      # given it will be passed the overlay before uninstalling it.
      #
      def Overlay.uninstall(name,&block)
        Overlay.get(name).uninstall(&block)
      end

      #
      # See OverlayCache#each_overlay.
      #
      def Overlay.each(&block)
        Overlay.cache.each_overlay(&block)
      end

      #
      # See OverlayCache#overlays_with?.
      #
      def Overlay.with(&block)
        Overlay.cache.overlays_with(&block)
      end

      #
      # Returns the overlays which contain the extension with the
      # matching _name_.
      #
      #   Overlay.with_extension?('exploits') # => [...]
      #
      def Overlay.with_extension(name)
        Overlay.with { |repo| repo.has_extension?(name) }
      end

      #
      # Returns +true+ if the cache has the extension with the matching
      # _name_, returns +false+ otherwise.
      #
      def Overlay.has_extension?(name)
        Overlay.each do |repo|
          return true if repo.has_extension?(name)
        end

        return false
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
      # Returns the path to the objects directory of the overlay.
      #
      def objects_dir
        File.expand_path(File.join(@path,OBJECTS_DIR))
      end

      #
      # Caches the objects contained within overlay.
      #
      def cache_objects
        require 'ronin/models'

        return ObjectContext.cache_objects_in(objects_dir)
      end

      #
      # Mirror the objects contained within the overlay.
      #
      def mirror_objects
        require 'ronin/models'

        return ObjectContext.mirror_objects_in(objects_dir)
      end

      #
      # Delete all objects that existed within the overlay.
      #
      def expunge_objects
        require 'ronin/models'

        return ObjectContext.expunge_objects_from(objects_dir)
      end

      #
      # Adds the overlay to the overlay cache. If a _block is given,
      # it will be passed the newly created Overlay after it has been
      # added to the cache.
      #
      def add(&block)
        Overlay.cache.add(self) do
          cache_objects
        end

        block.call(self) if block
        return self
      end

      #
      # Updates the overlay and reloads it's metadata. If a _block_
      # is given it will be called after the overlay has been updated.
      #
      def update(&block)
        if media_type
          Repertoire.update(:media => media_type, :path => @path, :uri => @uri)
        end

        mirror_objects
        return load_metadata(&block)
      end

      #
      # Removes the overlay from the overlay cache. If a _block_ is
      # given, it will be passed the overlay after it has been removed.
      #
      def remove(&block)
        Overlay.cache.remove(self)

        expunge_objects

        block.call(self) if block
        return self
      end

      #
      # Deletes the overlay then removes it from the overlay cache.
      # If a _block_ is given, it will be passed the overlay after it
      # has been uninstalled.
      #
      def uninstall(&block)
        Repertoire.delete(@path) do
          return remove(&block)
        end
      end

      #
      # Returns the paths of all extensions within the overlay.
      #
      def extension_paths
        directories
      end

      #
      # Passes each extension path to the specified _block_.
      #
      def each_extension_path(&block)
        extension_paths.each(&block)
      end

      #
      # Returns the names of all extensions within the overlay.
      #
      def extensions
        extension_paths.map { |dir| File.basename(dir) }
      end

      #
      # Passes each extension name to the specified _block_.
      #
      def each_extension(&block)
        extensions.each(&block)
      end

      #
      # Returns +true+ if the overlay contains the extension with the
      # specified _name_, returns +false+ otherwise.
      #
      def has_extension?(name)
        extensions.include?(name.to_s)
      end

      #
      # Loads an extension with the specified _name_ from the overlay.
      # If a _block_ is given, it will be passed the newly created
      # extension.
      #
      #   repo.extension('awesome') # => Extension
      #
      #   repo.extension('shellcode') do |ext|
      #     ...
      #   end
      #
      def extension(name,&block)
        name = name.to_s

        unless has_extension?(name)
          raise(ExtensionNotfound,"overlay #{name.dump} does not contain the extension #{name.dump}",caller)
        end

        return Extension.load_extension(File.join(@path,name),&block)
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
        @name = File.basename(@path)
        @license = nil

        @source = @uri
        @source_view = @source
        @website = @source_view

        @maintainers = []
        @description = nil

        if File.file?(metadata_path)
          doc = REXML::Document.new(open(metadata_path))
          overlay = doc.elements['/ronin-overlay']

          overlay.each_element('name[.]:first') do |name|
            @name = name.text.strip
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
