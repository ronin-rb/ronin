#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'repo/cache'
require 'repo/objectcache'
require 'repo/roninhandler'

module Ronin
  def Ronin.ronin
    @ronin ||= RoninHandler.new
  end

  def Ronin.ronin_require(category)
    Repo.cache.categories[name].each_value do |repository|
      category_dir = File.join(repository.path,name)
      load_file = File.join(category_dir,name+'.rb')

      if File.file?(load_file)
	$LOAD_PATH.unshift(category_dir) unless $LOAD_PATH.include?(category_dir)

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
end
