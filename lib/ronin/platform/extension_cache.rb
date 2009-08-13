#
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
#

require 'ronin/platform/extension'
require 'ronin/platform/exceptions/extension_not_found'

module Ronin
  module Platform
    class ExtensionCache < Hash

      #
      # Creates a new empty ExtensionCache object. If a _block_ is given
      # it will be passed the newly created ExtensionCache object.
      #
      def initialize(&block)
        super() do |hash,key|
          name = key.to_s

          hash[name] = load_extension(name)
        end

        at_exit do
          each_extension { |ext| ext.teardown! }
        end

        block.call(self) if block
      end

      #
      # Returns the sorted names of the extensions within the cache.
      #
      def names
        keys.sort
      end

      alias extensions values
      alias each_extension each_value

      #
      # Selects the extensions within the cache that match the specified
      # _block_.
      #
      def with(&block)
        values.select(&block)
      end

      #
      # Returns +true+ if the cache contains the extension with the
      # specified _name_, returns +false+ otherwise.
      #
      def has?(name)
        has_key?(name.to_s)
      end

      #
      # Loads the extension with the specified _name_. If no such extension
      # exists an ExtensionNotFound exception will be raised. If a _block_
      # is given, it will be passed the loaded extension.
      #
      def load_extension(name,&block)
        name = name.to_s

        unless Platform.overlays.has_extension?(name)
          raise(ExtensionNotFound,"extension #{name.dump} does not eixst",caller)
        end

        return Extension.load(name) do |ext|
          ext.setup!

          block.call(ext) if block
        end
      end

      #
      # Reloads the extensions within the extension cache. If _name_ is
      # given, the extension with the specified name will be reloaded.
      #
      def reload!(name=nil)
        reloader = lambda { |ext_name|
          self[ext_name].teardown! if has?(ext_name)

          self[ext_name] = load_extension(ext_name)
        }

        if name
          reloader.call(name)
        else
          each_key(&reloader)
        end

        return true
      end

    end
  end
end
