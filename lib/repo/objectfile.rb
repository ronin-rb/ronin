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

require 'og'

module Ronin
  module Repo
    class ObjectFile

      # Path of the Object Context
      attr_reader :path, String

      # Modification time of the file
      attr_reader :mtime, Time

      # Object Contexts found within the file
      attr_reader :contexts

      def initialize(path,mtime=File.mtime(path))
	@path = path
	@mtime = mtime
	@contexts = []
      end

      def self.timestamp(path)
	obj_file = ObjectFile.new(path,File.mtime(path))
	obj_file.save

	ronin_load_objects(path).each do |obj|
	  obj.cache(obj_file)
	end

	return obj_file
      end

      def is_fresh?
	File.mtime(@path)==@mtime
      end

      def is_stale?
	File.mtime(@path)!=@mtime
      end

      def timestamp
	# update the timestamp
	@mtime = File.mtime(@path)

	# update the object-file
	update
      end

      def cache
	# clear the contexts list
	@contexts.clear

	# load objects
	objs = ObjectContext.load_objects(@path)

	# populate the contexts list
	@contexts = objs.map { |obj| obj.context_name }

	# save the object-file first
	save

	# connect each object to this object-file and
	# save the object
	objs.each do |obj|
	  obj.object_file = self
	  obj.save
	end
      end

      def delete
	@contexts.each do |context|
	  if ObjectContext.is_object_context?(context)
	    ObjectContext.object_contexts[context].delete(:condition => ['object_file_oid = ?', self.oid])
	  end
	end
      end

    end
  end
end
