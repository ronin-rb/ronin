#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/cache/extension'
require 'ronin/cache/exceptions/extension_not_found'

module Ronin
  module Cache
    class ExtensionCache < Hash

      #
      # Creates a new empty ExtensionCache object. If a _block_ is given
      # it will be passed the newly created ExtensionCache object.
      #
      def initialize(&block)
        super() do |hash,key|
          hash[name] = load_extension(key.to_s)
        end

        catch('EXIT') do
          each_extension do |ext|
            ext.perform_teardown
          end
        end

        block.call(self) if block
      end

      #
      # Returns the names of all extensions within the cache.
      #
      def names
        keys
      end

      #
      # Returns the extensions within the cache.
      #
      def extensions
        values
      end

      #
      # Iterates over each extension within the cache, passing each to the
      # specified _block_.
      #
      def each_extension(&block)
        each_value(&block)
      end

      #
      # Selects the extensions within the cache that match the specified
      # _block_.
      #
      def extensions_with(&block)
        values.select(&block)
      end

      #
      # Returns +true+ if the cache contains the extension with the
      # specified _name_, returns +false+ otherwise.
      #
      def has_extension?(name)
        has_key?(name.to_s)
      end

      #
      # Loads the extension with the specified _name_. If no such extension
      # exists an ExtensionNotFound exception will be raised. If a _block_
      # is given, it will be passed the loaded extension.
      #
      def load_extension(name,&block)
        name = name.to_s

        unless Extension.exists?(name)
          raise(ExtensionNotFound,"extension #{name.dump} does not eixst",caller)
        end

        return Extension.load(name) do |ext|
          ext.perform_setup

          block.call(ext) if block
        end
      end

    end
  end
end
