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

require 'ronin/cache/repository'
require 'ronin/cache/object_context'

module Ronin
  #
  # See Cache::Repository.extensions.
  #
  def Ronin.extensions
    Cache::Repository.extensions
  end

  #
  # See Cache::Repository.extension.
  #
  def Ronin.extension(name,&block)
    Cache::Repository.extension(name,&block)
  end

  #
  # See Cache::ObjectContext.load_objects.
  #
  def Ronin.ronin_load_objects(path)
    Cache::ObjectContext.load_objects(path)
  end

  #
  # See Cache::ObjectContext.load_object.
  #
  def Ronin.ronin_load_object(type,path)
    Cache::ObjectContext.load_object(type,path)
  end

  protected

  #
  # Provides transparent access to extensions.
  #
  #   Ronin.shellcode # => Extension
  #
  #   Ronin.shellcode do |ext|
  #     ...
  #   end
  #
  def Ronin.method_missing(sym,*args,&block)
    if args.length==0
      name = sym.id2name

      # return an extension if present
      if Cache::Repository.has_extension?(name)
        return Cache::Repository.extension(name,&block)
      end
    end

    return super(sym,*args,&block)
  end
end
