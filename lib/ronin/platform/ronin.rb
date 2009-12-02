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

require 'ronin/platform/platform'

require 'extlib'

module Ronin
  protected

  #
  # Provides transparent access to Platform.extension via constants.
  #
  # @param [String] name
  #   The constant name to map to an extension in the extension cache.
  #
  # @return [Extension]
  #   The extension that maps to the constant name.
  #
  # @raise [NameError]
  #   No extension could be found in the extension cache, that maps to the
  #   constant name.
  #
  # @example
  #   Ronin::Shellcode
  #   # => #<Ronin::Platform::Extension: @name="shellcode" ...>
  #
  def Ronin.const_missing(name)
    name = name.to_s
    ext_name = name.snake_case

    if Platform.has_extension?(ext_name)
      return Platform.extension(ext_name)
    end

    return super(name)
  end

  #
  # Provides transparent access to Platform.extension via methods.
  #
  # @param [Symbol, String] name
  #   The name of the extension to search for within the extension cache.
  #
  # @yield [ext]
  #   If a block is given, it will be passed the extension which has the
  #   matching name.
  #
  # @yieldparam [Extension] ext
  #   The matching extension.
  #
  # @return [Extension]
  #   The matching extension.
  #
  # @raise [NoMethodError]
  #   No extension could be found in the extension cache with the
  #   matching name.
  #
  # @example
  #   shellcode
  #   # => #<Ronin::Platform::Extension: ...>
  #
  # @example
  #   shellcode do |ext|
  #     puts ext.exposed_methods
  #   end
  #
  def method_missing(name,*args,&block)
    if args.length == 0
      ext_name = name.id2name

      # return an extension if available
      if Platform.has_extension?(ext_name)
        return Platform.extension(ext_name,&block)
      end
    end

    return super(name,*args,&block)
  end
end
