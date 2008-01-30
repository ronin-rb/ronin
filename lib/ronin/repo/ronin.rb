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

require 'ronin/repo/repo'
require 'ronin/repo/objectcontext'

module Ronin
  def Ronin.extensions
    Repo::Repository.cache.extensions.keys
  end

  def Ronin.extension(name)
    Repo::Repository.cache.extension(name)
  end

  def Ronin.ronin_load_objects(path)
    Repo::ObjectContext.load_objects(path)
  end

  def Ronin.ronin_load_object(type,path)
    Repo::ObjectContext.load_object(type,path)
  end

  protected

  def Ronin.method_missing(sym,*args,&block)
    if args.length==0
      name = sym.id2name

      # return an extension if present
      if Repo::Repository.cache.has_extension?(name)
        ext = Repo::Repository.cache.extension(name)

        block.call(ext) if block
        return ext
      end
    end

    return super(sym,*args,&block)
  end
end
