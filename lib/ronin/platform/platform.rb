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

require 'ronin/platform/overlay_cache'
require 'ronin/platform/object_cache'
require 'ronin/platform/extension_cache'

module Ronin
  module Platform
    #
    # Load the overlay cache from the given _path_. If a _block_ is
    # given it will be passed the current overlay cache.
    #
    #   Overlay.load_overlays('/custom/overlays/cache.yaml')
    #   # => #<Ronin::Platform::OverlayCache: ...>
    #
    def Platform.load_overlays(path)
      @@ronin_overlay_cache = OverlayCache.new(path)
    end

    #
    # Returns the current overlay cache, or loads the default overlay
    # cache if not already loaded.
    #
    def Platform.overlays
      @@ronin_overlay_cache ||= OverlayCache.new
    end

    #
    # Adds a new Overlay with the given _options_. If a _block_ is given
    # it will be passed the newly added overlay.
    #
    # _options_ must contain the following key:
    # <tt>:path</tt>:: The path of the overlay.
    #
    # _options_ may contain the following key:
    # <tt>:media</tt>:: The media of the overlay.
    # <tt>:uri</tt>:: The URI of the overlay.
    #
    def Platform.add(options={},&block)
      path = options[:path]

      unless path
        raise(ArgumentError,":path must be passed to Platform.add",caller)
      end

      media = options[:media]
      uri = options[:uri]

      overlay = Overlay.new(path,media,uri)

      Platform.overlays.add(overlay) do
        ObjectCache.cache(overlay.objects_dir)
      end

      return overlay
    end

    #
    # Installs an Overlay specified by _options_ into the
    # OverlayCache::CACHE_DIR. If a _block_ is given, it will be
    # passed the newly created overlay after it has been added to
    # the overlay cache.
    #
    # _options_ must contain the following key:
    # <tt>:uri</tt>:: The URI of the overlay.
    #
    # _options_ may contain the following key:
    # <tt>:media</tt>:: The media of the overlay.
    #
    def Platform.install(options={},&block)
      options = options.merge(:into => OverlayCache::CACHE_DIR)

      Repertoire.checkout(options) do |path,media,uri|
        return Platform.add(:path => path, :media => media, :uri => uri)
      end
    end

    #
    # Updates all previously installed overlays. If a _block_ is given
    # it will be called after the overlays have been updated.
    #
    def Platform.update(&block)
      Platform.overlays.update do |overlay|
        ObjectCache.mirror(overlay.objects_dir)
      end

      block.call if block
      return nil
    end

    #
    # Removes the overlay with the specified _name_. If no overlay
    # has the specified _name_, an OverlayNotFound exception will be
    # raised. If a _block_ is given, it will be called after the overlay
    # has been removed.
    #
    def Platform.remove(name,&block)
      Platform.overlays.remove(name,&block)
      return nil
    end

    #
    # Uninstalls the overlay with the specified _name_. If no overlay
    # has the specified _name_, an OverlayNotFound exception will be
    # raised. If a _block_ is given, it will be called after the overlay
    # has been uninstalled.
    #
    def Platform.uninstall(name,&block)
      Platform.remove(name) do |overlay|
        ObjectCache.expunge(overlay.objects_dir)
      end

      block.call if block
      return nil
    end

    #
    # Returns the names of all extensions within the overlay cache.
    #
    def Platform.extension_names
      names = []

      Platform.overlays.each_overlay do |overlay|
        overlay.extensions.each do |name|
          names << name unless names.include?(name)
        end
      end

      return names
    end

    #
    # Returns +true+ if the cache has the extension with the matching
    # _name_, returns +false+ otherwise.
    #
    def Platform.has_extension?(name)
      Platform.overlays.each_overlay do |overlay|
        return true if overlay.has_extension?(name)
      end

      return false
    end

    #
    # Returns a +Hash+ of all loaded extensions. Extensions can be loaded
    # on-the-fly by accessing the +Hash+.
    #
    #   Platform.extensions['shellcode']
    #   # => #<Ronin::Platform::Extension: ...>
    #
    def Platform.extensions
      @@ronin_extension_cache ||= ExtensionCache.new
    end

    #
    # Loads the extension with the specified _name_. If a _block_ is given
    # it will be passed the loaded extension. If the extension cannot be
    # loaded, an ExtensionNotFound exception will be raised.
    #
    def Platform.extension(name,&block)
      ext = Platform.extensions[name]

      block.call(ext) if block
      return ext
    end
  end
end
