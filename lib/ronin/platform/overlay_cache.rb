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

require 'ronin/platform/exceptions/overlay_cached'
require 'ronin/platform/exceptions/overlay_not_found'
require 'ronin/platform/overlay'
require 'ronin/config'

require 'yaml'

module Ronin
  module Platform
    class OverlayCache < Hash

      # Default overlay cache directory
      CACHE_DIR = File.join(Config::PATH,'overlays')

      # Name of the overlay cache file
      CACHE_FILE = 'cache.yaml'

      # Directory containing the overlays
      attr_reader :directory

      # Path of cache file
      attr_reader :path

      #
      # Create a new OverlayCache object with the specified _directory_. The
      # _directory_ defaults to <tt>CACHE_DIR</tt>. If a _block_ is given,
      # it will be passed the newly created OverlayCache object.
      #
      def initialize(directory=CACHE_DIR,&block)
        super()

        @directory = File.expand_path(dir)
        @path = File.join(@directory,CACHE_FILE)
        @dirty = false

        if File.file?(@path)
          descriptions = YAML.load(File.read(@path))

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
      # Returns +true+ if the overlay cache has been modified, returns
      # +false+ otherwise.
      #
      def dirty?
        @dirty == true
      end

      alias names keys
      alias overlays values
      alias each_overlay each_value

      #
      # Returns the Ovlerays which match the specified _block_.
      #
      #   cache.with do |overlay|
      #     overlay.author == 'the dude'
      #   end
      #
      def with(&block)
        values.select(&block)
      end

      #
      # Returns +true+ if the cache contains the Overlay with the
      # matching _name_, returns +false+ otherwise.
      #
      def has?(name)
        has_key?(name.to_s)
      end

      #
      # Returns the Overlay with the matching _name_.
      #
      def get(name)
        name = name.to_s

        unless has_overlay?(name)
          raise(OverlayNotFound,"overlay #{name.dump} is not present in cache #{self.to_s.dump}",caller)
        end

        return self[name]
      end

      #
      # Returns the paths of the Overlays contained in the cache.
      #
      def paths
        overlays.map { |overlay| overlay.path }
      end

      #
      # Returns +true+ if the extension with the specified _name_ exists
      # within any of the overlays in the overlay cache, returns +false+
      # otherwise.
      #
      def has_extension?(name)
        each_overlay do |overlay|
          return true if overlay.extensions.include?(name)
        end

        return false
      end

      #
      # Returns the names of all extensions within the overlay cache.
      #
      def extensions
        ext_names = []

        each_overlay do |overlay|
          overlay.extensions.each do |name|
            ext_names << name unless ext_names.include?(name)
          end
        end

        return ext_names
      end

      #
      # Returns the paths of all extensions with the specified _name_.
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
      # Adds the specified _overlay_ with the specified _name_ to the
      # overlay cache.
      #
      def []=(name,overlay)
        super(name.to_s,overlay)
        dirty!

        overlay.activate!
        return overlay
      end

      #
      # Adds the _overlay_ to the cache. If a _block_ is given, it will
      # be passed the cache after the _overlay_ is added. The _overlay_
      # will be returned.
      #
      #   cache.add(overlay)
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      #   cache.add(overlay) do |cache|
      #     puts "Overlay #{overlay} added"
      #   end
      #
      def add(overlay,&block)
        name = overlay.name.to_s

        if has_overlay?(name)
          raise(OverlayCached,"overlay #{name.dump} already present in the cache #{self.to_s.dump}",caller)
        end

        self[overlay.name.to_s] = overlay

        block.call(self) if block
        return self
      end

      #
      # Updates all the cached Overlays. If a _block_ is given it will
      # be passed the overlays as they are updated.
      #
      #   update
      #   # => #<Ronin::Platform::OverlayCache: ...>
      #
      #   update do |overlay|
      #     puts "#{overaly} is updated"
      #   end
      #
      def update(&block)
        overlays.each do |overlay|
          overlay.deactive!
          overlay.update(&block)
          overlay.active!
        end

        return self
      end

      #
      # Removes the overlay with the specified _name_ from the cache. If a
      # _block_ is given, it will be passed the removed overlay. The cache
      # will be returned, after the overlay is removed.
      #
      #   cache.remove('hello_word')
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      #   cache.remove('hello_word') do |overlay|
      #     puts "Overlay #{overlay} removed"
      #   end
      #
      def remove(name,&block)
        name = name.to_s

        overlay = get(name)
        overlay.deactive!

        delete_if { |key,value| key == name }
        dirty!

        block.call(overlay) if block
        return self
      end

      #
      # Uninstalls the overlay with the specified _name_. If a _block_
      # is given, it will be passed the uninstalled overlay. The cache
      # will be returned, after the overlay is removed.
      #
      #   cache.uninstall('hello_word')
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      #   cache.uninstall('hello_word') do |overlay|
      #     puts "Overlay #{overlay} uninstalled"
      #   end
      #
      def uninstall(name,&block)
        remove do |overlay|
          overlay.uninstall(&block)
        end
      end

      #
      # Saves the overlay cache.
      #
      def save
        return self unless dirty?

        unless File.directory?(@directory)
          FileUtils.mkdir_p(@directory)
        end

        File.open(@path,'w') do |output|
          descriptions = overlays.map do |overlay|
            {
              :path => overlay.path,
              :media => overlay.media_type,
              :uri => overlay.uri
            }
          end

          YAML.dump(descriptions,output)
        end

        block.call if block
        return self
      end

      #
      # Returns the +path+ of the cache.
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
