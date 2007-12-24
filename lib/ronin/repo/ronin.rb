#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/repo/repo'
require 'ronin/repo/objectcontext'

module Ronin
  def Ronin.applications
    Repo.cache.applications.keys
  end

  def Ronin.application(name)
    Repo.cache.application(name.to_s)
  end

  def Ronin.ronin_require(category)
    Repo.cache.applications[name].each_value do |repository|
      app_dir = File.join(repository.path,name)
      load_file = File.join(app_dir,name+'.rb')

      if File.file?(load_file)
        $LOAD_PATH.unshift(app_dir) unless $LOAD_PATH.include?(app_dir)

        require load_file
      end
    end
  end

  def Ronin.ronin_load_objects(path)
    Repo::ObjectContext.load_objects(path)
  end

  def Ronin.ronin_load_object(type,path)
    Repo::ObjectContext.load_object(type,path)
  end

  protected

  def Ronin.method_missing(sym,*args)
    if args.length==0
      name = sym.id2name

      # return an application if present
      return Repo.cache.application(name) if Repo.cache.has_application?(name)
    end

    raise(NoMethodError,name)
  end
end
