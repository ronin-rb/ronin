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

require 'ronin/platform/platform'

require 'extlib'

module Ronin
  protected

  #
  # Provides transparent access to Platform.extension via constants.
  #
  #   Ronin::Shellcode
  #   # => #<Ronin::Platform::Extension: ...>
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
  #   shellcode
  #   # => #<Ronin::Platform::Extension: ...>
  #
  #   shellcode do |ext|
  #     ...
  #   end
  #
  def method_missing(sym,*args,&block)
    if args.length == 0
      name = sym.id2name

      # return an extension if available
      if Platform.has_extension?(name)
        return Platform.extension(name,&block)
      end
    end

    return super(sym,*args,&block)
  end
end
