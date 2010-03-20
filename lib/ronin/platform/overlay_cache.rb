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
    class OverlayCache < Array

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
        self.clear

        Overlay.all.each do |overlay|
          self << overlay if overlay.compatible?
        end

        return self
      end

      alias reload! load!

      #
      # The names of the overlays in the overlay cache.
      #
      # @return [Array<String>]
      #   The overlay names.
      #
      def names
        self.map { |overlay| overlay.to_s }
      end

      #
      # @return [Array]
      #   The paths of the overlays contained in the cache.
      #
      def paths
        self.map { |overlay| overlay.path }
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
        self.any? { |overlay| overlay.extensions.include?(name) }
      end

      #
      # @return [Array]
      #   The names of all extensions within the overlay cache.
      #
      def extensions
        ext_names = []

        self.each do |overlay|
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

        self.each do |overlay|
          overlay.extension_paths.each do |path|
            ext_paths << path if File.basename(path) == file_name
          end
        end

        return ext_paths
      end

    end
  end
end
