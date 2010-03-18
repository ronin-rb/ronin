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

require 'ronin/platform/exceptions/overlay_cached'
require 'ronin/platform/exceptions/overlay_not_found'
require 'ronin/platform/object_cache'
require 'ronin/platform/overlay'
require 'ronin/platform/config'

module Ronin
  module Platform
    class OverlayCache < Hash

      #
      # Create a new OverlayCache object.
      #
      # @yield [cache]
      #   If a block is given, it will be passed the newly created overlay
      #   cache.
      #
      # @yieldparam [OverlayCache] cache
      #   The newly created overly cache.
      #
      def initialize(&block)
        super()
        load!()

        block.call(self) if block
      end

      #
      # Loads all overlays.
      #
      def load!
        Overlay.all.each do |overlay|
          if overlay.compatible?
            self[overlay.name] = overlay
          end
        end

        return true
      end

      #
      # Clears the overlay cache, and reloads it's contents from the same
      # cache-file.
      #
      def reload!
        clear
        load!
      end

      #
      # @return [Boolean]
      #   Specifies whether the overlay cache has been modified.
      #
      def dirty?
        @dirty == true
      end

      #
      # @return [Array]
      #   The sorted names of the overlays within the cache.
      #
      def names
        keys.sort
      end

      alias overlays values
      alias each_overlay each_value

      #
      # Selects overlays from the overlay cache.
      #
      # @yield [overlay]
      #   The block that will be passed each overlay. Overlays will be
      #   selected based on the return value of the block.
      #
      # @yieldparam [Overlay] overlay
      #   An overlay from the cache.
      #
      # @return [Array]
      #   The selected overlay.
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
      # Searches for the overlay with the given name.
      #
      # @param [String] name
      #   The name of the overlay to search for.
      #
      # @return [Boolean]
      #   Specifies whether the cache contains the Overlay with the
      #   matching name.
      #
      def has?(name)
        has_key?(name.to_s)
      end

      #
      # Searches for the overlay with the given name.
      #
      # @param [String] name
      #   The name of the overlay to search for.
      #
      # @return [Overlay]
      #   The overlay with the matching name.
      #
      # @raise [OverlayNotFound]
      #   No overlay with the matching name could be found in the
      #   overlay cache.
      #
      def get(name)
        name = name.to_s

        unless has?(name)
          raise(OverlayNotFound,"overlay #{name.dump} is not present in cache #{self.to_s.dump}",caller)
        end

        return self[name]
      end

      #
      # @return [Array]
      #   The paths of the overlays contained in the cache.
      #
      def paths
        overlays.map { |overlay| overlay.path }
      end

      #
      # Searches for an extension within all overlays in the overlay cache.
      #
      # @param [String] name
      #   The name of the extension to search for.
      #
      # @return [Boolean]
      #   Specifies whether the extension with the specified name exists
      #   within any of the overlays in the overlay cache.
      #
      def has_extension?(name)
        each_overlay do |overlay|
          return true if overlay.extensions.include?(name)
        end

        return false
      end

      #
      # @return [Array]
      #   The names of all extensions within the overlay cache.
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
      # Selects the paths of extensions that have the given name, in
      # all overlays in the overlay cache.
      #
      # @param [String] name
      #   The name of the extension to gather paths for.
      #
      # @return [Array]
      #   The paths of all extensions with the matching name.
      #
      def extension_paths(name)
        file_name = "#{name}.rb"
        ext_paths = []

        each_overlay do |overlay|
          overlay.extension_paths.each do |path|
            ext_paths << path if File.basename(path) == file_name
          end
        end

        return ext_paths
      end

      #
      # Adds an overlay with the given name to the overlay cache.
      #
      # @param [String] name
      #   The name of the overlay.
      #
      # @param [Overlay] overlay
      #   The new overlay.
      #
      # @return [Overlay]
      #   The new overlay.
      #
      def []=(name,overlay)
        super(name.to_s,overlay)

        overlay.activate!
        return overlay
      end

      #
      # Deletes an overlay with the given name from the overlay cache.
      #
      # @param [String] name
      #   The name of the overlay.
      #
      # @return [Overlay]
      #   The deleted overlay.
      #
      # @since 0.4.0
      #
      def delete(name)
        overlay = super(name.to_s)

        overlay.deactive! if overlay
        return overlay
      end

      #
      # Adds an overlay to the cache.
      #
      # @param [Overlay] overlay
      #   The overlay to add.
      #
      # @yield [overlay]
      #   If a block is given, it will be passed the overlay after it has
      #   been added to the cache.
      #
      # @yieldparam [Overlay] overlay
      #   The newly added overlay.
      #
      # @return [Overlay]
      #   The newly added overlay.
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
      # @raise [OverlayCache]
      #   The specified overlay has already been cached.
      #
      def add!(overlay,&block)
        name = overlay.name.to_s

        if has?(name)
          raise(OverlayCached,"overlay #{name.dump} is already present in the cache #{self.to_s.dump}",caller)
        end

        self[overlay.name.to_s] = overlay
        ObjectCache.cache(overlay.cache_dir)

        block.call(overlay) if block
        return overlay
      end

      #
      # Updates all overlays in the cache.
      #
      # @yield [overlay]
      #   If a block is given, it will be passed each overlay after it has
      #   been updated.
      #
      # @yieldparam [Overlay] overlay
      #   Each updated overlay in the cache.
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
      def update!(&block)
        overlays.each do |overlay|
          # de-activate the overlay
          overlay.deactive!

          overlay.update!

          # re-activate the overlay
          overlay.activate!

          # sync the object cache
          ObjectCache.sync(overlay.cache_dir)

          block.call(overlay) if block
        end

        return self
      end

      #
      # Uninstalls an overlay and its contents from the overlay cache.
      #
      # @param [String] name
      #   The name of the overlay to uninstall.
      # 
      # @yield [overlay]
      #   If a block is given, it will be passed the overlay, after it has
      #   been uninstalled.
      #
      # @yieldparam [Overlay] overlay
      #   The uninstalled overlay.
      #
      # @return [nil]
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
      def uninstall!(name,&block)
        name = name.to_s

        unless (overlay = delete(name))
          raise(OverlayCached,"overlay #{name.dump} is already present in the cache",caller)
        end

        overlay.uninstall!(&block)

        ObjectCache.clean(overlay.cache_dir)
        return nil
      end

    end
  end
end
