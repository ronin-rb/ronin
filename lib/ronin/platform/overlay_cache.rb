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
require 'ronin/platform/config'

require 'yaml'

module Ronin
  module Platform
    class OverlayCache < Hash

      # Path of cache file
      attr_reader :path

      #
      # Create a new OverlayCache object with the specified _path_. The
      # _path_ defaults to <tt>Config::OVERLAY_CACHE_PATH</tt>. If a
      # _block_ is given, it will be passed the newly created OverlayCache
      # object.
      #
      def initialize(path=Config::OVERLAY_CACHE_PATH,&block)
        super()

        @path = File.expand_path(path)

        if File.file?(@path)
          descriptions = YAML.load(File.read(@path))

          if descriptions.kind_of?(Array)
            descriptions.each do |overlay|
              if overlay.kind_of?(Hash)
                add(Overlay.new(overlay[:path],overlay[:media],overlay[:uri]))
              end
            end
          end
        end

        block.call(self) if block
      end

      alias names keys
      alias overlays values
      alias each_overlay each_value

      #
      # Returns the Ovlerays which match the specified _block_.
      #
      #   cache.overlays_with do |overlay|
      #     overlay.author == 'the dude'
      #   end
      #
      def overlays_with(&block)
        values.select(&block)
      end

      #
      # Returns +true+ if the cache contains the Overlay with the
      # matching _name_, returns +false+ otherwise.
      #
      def has_overlay?(name)
        has_key?(name.to_s)
      end

      #
      # Returns the Overlay with the matching _name_.
      #
      def get_overlay(name)
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

        self << overlay

        block.call(self) if block
        return self
      end

      #
      # Removes the _overlay_ from the cache. If a _block_ is given, it
      # will be passed the cache. The cache will be returned, after the
      # _overlay_ is removed.
      #
      #   cache.remove(overlay)
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      #   cache.remove(overlay) do |cache|
      #     puts "Overlay #{overlay} removed"
      #   end
      #
      def remove(overlay,&block)
        name = overlay.name.to_s

        unless has_overlay?(name)
          raise(OverlayNotFound,"overlay #{name.dump} is not present in the cache #{self.to_s.dump}",caller)
        end

        delete_if { |key,value| key == name }

        block.call(self) if block
        return self
      end

      #
      # Updates all the cached Overlays. If a _block_ is given it will
      # be passed the cache.
      #
      #   update
      #   # => #<Ronin::Platform::Overlay: ...>
      #
      #   update do |cache|
      #     puts "#{cache} is updated"
      #   end
      #
      def update(&block)
        overlays.each { |overlay| overlay.update }

        block.call(self) if block
        return self
      end

      #
      # Saves the cache to the given _output_path_, where _output_path_
      # defaults to +@path+. If a _block_ is given, it will be passed
      # the cache before the cache has been saved.
      #
      def save(output_path=@path,&block)
        parent_dir = File.dirname(output_path)

        unless File.directory?(parent_dir)
          FileUtils.mkdir_p(parent_dir)
        end

        block.call(self) if block

        File.open(output_path,'w') do |output|
          descriptions = overlays.map do |overlay|
            {
              :media_type => overlay.media_type,
              :path => overlay.path,
              :uri => overlay.uri
            }
          end

          YAML.dump(descriptions,output)
        end

        return self
      end

      #
      # Adds the specified _overlay_ to the cache.
      #
      def <<(overlay)
        self[overlay.name.to_s] = overlay
      end

      #
      # Returns the +path+ of the cache.
      #
      def to_s
        @path.to_s
      end

    end
  end
end
