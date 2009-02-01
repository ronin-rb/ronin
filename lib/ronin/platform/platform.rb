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

require 'ronin/platform/overlay'
require 'ronin/platform/extension'

module Ronin
  module Platform
    #
    # See Overlay.cache.
    #
    def Platform.overlays
      Overlay.cache
    end

    #
    # See Extension.names.
    #
    def Platform.extension_names
      Extension.names
    end

    #
    # See Overlay.has_extension?.
    #
    def Platform.has_extension?(name)
      Overlay.has_extension?(name)
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
