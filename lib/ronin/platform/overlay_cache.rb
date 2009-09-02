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

require 'ronin/platform/exceptions/overlay_cached'
require 'ronin/platform/exceptions/overlay_not_found'
require 'ronin/platform/overlay'
require 'ronin/config'

require 'yaml'

module Ronin
  module Platform
    class OverlayCache < Hash

      # Default overlay cache directory
      CACHE_DIR = File.join(Ronin::Config::PATH,'overlays')

      # Name of the overlay cache file
      CACHE_FILE = File.join(Ronin::Config::PATH,'overlays.yaml')

      # Path of cache file
      attr_reader :path

      #
      # Create a new OverlayCache object.
      #
      # @param [String] path The path of the overlay cache file.
      #
      # @yield [cache] If a block is given, it will be passed the newly
      #                created overlay cache.
      # @yieldparam [OverlayCache] cache The newly created overly cache.
      #
      def initialize(path=CACHE_FILE,&block)
        super()

        @path = path
        @dirty = false

        if File.file?(@path)
          descriptions = YAML.load_file(@path)

          if descriptions.kind_of?(Array)
            descriptions.each do |overlay|
              if overlay.kind_of?(Hash)
                overlay = Overlay.new(
                  overlay[:path],
                  overlay[:media],
                  overlay[:uri]
                )

                self[overlay.name] = overlay
              end
            end
          end
        end

        at_exit(&method(:save))

        block.call(self) if block
      end

      #
      # @return [true, false] Specifies whether the overlay cache has been
      #                       modified.
      #
      def dirty?
        @dirty == true
      end

      #
      # @return [Array] The sorted names of the overlays within the cache.
      #
      def names
        keys.sort
      end

      alias overlays values
      alias each_overlay each_value

      #
      # Selects overlays from the overlay cache.
      #
      # @yield [overlay] The block that will be passed each overlay.
      #                  Overlays will be selected based on the return
      #                  value of the block.
      # @yieldparam [Overlay] overlay An overlay from the cache.
      #
      # @return [Array] The selected overlay.
      #
      # @example
      #   cache.with do |overlay|
      #     overlay.author == 'the dude'
      #   end
      #
      def with(&block)
        values.select(&block)
      end

      #
      # Searches for the overlay with the specified _name_.
      #
      # @param [String] name The name of the overlay to search for.
      #
      # @return [true, false] Specifies whether the cache contains the
      #                       Overlay with the matching _name_.
      #
      def has?(name)
        has_key?(name.to_s)
      end

      #
      # Searches for the overlay with the specified _name_.
      #
      # @param [String] name The name of the overlay to search for.
      #
      # @return [Overlay] The overlay with the matching _name_.
      # @raise [OverlayNotFound] No overlay with the matching _name_ could
      #                          be found in the overlay cache.
      #
      def get(name)
        name = name.to_s

        unless has?(name)
          raise(OverlayNotFound,"overlay #{name.dump} is not present in cache #{self.to_s.dump}",caller)
        end

        return self[name]
      end

      #
      # @return [Array] The paths of the overlays contained in the cache.
      #
      def paths
        overlays.map { |overlay| overlay.path }
      end

      #
      # Searches for an extension within all overlays in the overlay cache.
      #
      # @param [String] name The name of the extension to search for.
      #
      # @return [true, false] Specifies whether the extension with the
      #                       specified _name_ exists within any of the
      #                       overlays in the overlay cache.
      #
      def has_extension?(name)
        each_overlay do |overlay|
          return true if overlay.extensions.include?(name)
        end

        return false
      end

      #
      # @return [Array] The names of all extensions within the overlay
      #                 cache.
      #
      def extensions
        ext_names = []

        each_overlay do |overlay|
          overlay.extensions.each do |name|
            ext_names << name unless ext_names.include?(name)
          end
        end

        return ext_names.sort
      end

      #
      # Selects the paths of extensions that have the specified _name_, in
      # all overlays in the overlay cache.
      #
      # @param [String] name The name of the extension to gather paths for.
      #
      # @return [Array] The paths of all extensions with the matching
      #                 _name_.
      #
      def extension_paths(name)
        ext_paths = []

        each_overlay do |overlay|
          overlay.extension_paths.each do |path|
            ext_paths << path if File.basename(path) == name
          end
        end

        return ext_paths
      end

      #
      # Adds an overlay with the specified _name_ to the overlay cache.
      #
      # @param [String] name The name of the overlay.
      # @param [Overlay] overlay The new overlay.
      #
      # @return [Overlay] overlay The new overlay.
      #
      def []=(name,overlay)
        super(name.to_s,overlay)

        overlay.activate!
        return overlay
      end

      #
      # Adds an overlay to the cache.
      #
      # @param [Overlay] overlay The overlay to add.
      #
      # @yield [overlay] If a block is given, it will be passed the overlay
      #                  after it has been added to the cache.
      # @yieldparam [Overlay] overlay The newly added overlay.
      # @return [Overlay] The newly added overlay.
      #
      # @example
      #   cache.add(overlay)
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      # @example
      #   cache.add(overlay) do |cache|
      #     puts "Overlay #{overlay} added"
      #   end
      #
      # @raise [OverlayCache] The specified _overlay_ has already been
      #                       cached.
      #
      def add(overlay,&block)
        name = overlay.name.to_s

        if has?(name)
          raise(OverlayCached,"overlay #{name.dump} is already present in the cache #{self.to_s.dump}",caller)
        end

        self[overlay.name.to_s] = overlay
        dirty!

        block.call(overlay) if block
        return overlay
      end

      #
      # Updates all overlays in the cache.
      #
      # @yield [overlay] If a block is given, it will be passed each
      #                  overlay after it has been updated.
      # @yieldparam [Overlay] overlay Each updated overlay in the cache.
      #
      # @example
      #   update
      #   # => #<Ronin::Platform::OverlayCache: ...>
      #
      # @example
      #   update do |overlay|
      #     puts "#{overaly} is updated"
      #   end
      #
      def update(&block)
        overlays.each do |overlay|
          overlay.deactivate!
          overlay.update(&block)
          overlay.active!
        end

        return self
      end

      #
      # Removes an overlay from the overlay cache, but leaves the contents
      # of the overlay intact.
      #
      # @param [String] name The name of the overlay to remove.
      #
      # @yield [overlay] If a block is given, it will be passed the removed
      #                  overlay.
      # @yieldparam [Overlay] overlay The removed overlay.
      # @return [Overlay] The removed overlay.
      #
      # @example
      #   cache.remove('hello_word')
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      # @example
      #   cache.remove('hello_word') do |overlay|
      #     puts "Overlay #{overlay} removed"
      #   end
      #
      def remove(name,&block)
        name = name.to_s

        overlay = get(name)
        overlay.deactivate!

        delete_if { |key,value| key == name }
        dirty!

        block.call(overlay) if block
        return overlay
      end

      #
      # Uninstalls an overlay and its contents from the overlay cache.
      #
      # @param [String] name The name of the overlay to uninstall.
      # 
      # @yield [overlay] If a block is given, it will be passed the
      #                  overlay, after it has been uninstalled.
      # @yieldparam [Overlay] overlay The uninstalled overlay.
      #
      # @example
      #   cache.uninstall('hello_word')
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      # @example
      #   cache.uninstall('hello_word') do |overlay|
      #     puts "Overlay #{overlay} uninstalled"
      #   end
      #
      def uninstall(name,&block)
        remove(name) do |overlay|
          overlay.uninstall(&block)
        end

        return nil
      end

      #
      # Saves the overlay cache to the path.
      #
      def save
        return false unless dirty?

        parent_directory = File.dirname(@path)

        unless File.directory?(parent_directory)
          FileUtils.mkdir_p(parent_directory)
        end

        File.open(@path,'w') do |output|
          descriptions = overlays.map do |overlay|
            {
              :path => overlay.path,
              :media => overlay.media,
              :uri => overlay.uri
            }
          end

          YAML.dump(descriptions,output)
        end

        return true
      end

      #
      # @return [String] The path of the cache.
      #
      def to_s
        @path.to_s
      end

      protected

      #
      # Marks the overlay cache as dirty.
      #
      def dirty!
        @dirty = true
      end

    end
  end
end
