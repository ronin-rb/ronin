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
      attr_reader :contexts, Array

      def initialize(path,mtime=File.mtime(path))
	@path = File.expand_path(path)
	@mtime = mtime
	@contexts = []
      end

      def self.timestamp(path)
	obj_file = ObjectFile.new(path,File.mtime(path))
	obj_file.cache

	return obj_file
      end

      def is_fresh?
	File.mtime(@path)==@mtime
      end

      def is_stale?
	File.mtime(@path)!=@mtime
      end

      def cache
	# clean out the stale objects
	clean

	# load objects
	objs = ObjectContext.load_objects(@path)

	# populate the contexts list
	@contexts = objs.map { |obj| obj.context_name }

	# update the timestamp
	@mtime = File.mtime(@path)

	# connect each object to this object-file and
	# save the object
	objs.each { |obj| obj.save }

	# save the object-file first
	save
      end

      def clean
	@contexts.each do |context|
	  if ObjectContext.is_object_context?(context)
	    objs = ObjectContext.object_contexts[context].find(:condition => ['object_path = ?', @path])
	    objs.each { |obj| obj.delete }
	  end
	end

	# clear the contexts list
	@contexts.clear
      end

      def expunge
	clean
	delete
      end

    end
  end
end
