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

require 'ronin/cacheable'

module Ronin
  module Cache
    class ObjectFile

      include Cacheable

      # Path to an object-context file.
      property :path, :string

      # Modification time of the file
      property :mtime, :datetime

      # Object-contexts found within the file
      property :contexts, :array

      #
      # Creates a new ObjectFile object with the specified _path_ and the
      # given _mtime_. If a _block_ is given, it will be passed the newly
      # created ObjectFile object.
      #
      #   ObjectFile.new(my_app,'/path/to/obj.rb') # => ObjectFile
      #
      def initialize(path,mtime=File.mtime(path),&block)
        @path = File.expand_path(path)
        @mtime = mtime
        @contexts = []

        block.call(self) if block
      end

      #
      # Timestamps the object-contexts within the specified _path_.
      #
      def ObjectFile.timestamp(path)
        ObjectFile.new(path,File.mtime(path)) do |file|
          file.cache
        end
      end

      #
      # Returns +true+ if the object-files mtime is not older than the
      # mtime of the object-file path, returns +false+ otherwise.
      #
      def is_fresh?
        File.mtime(@path)==@mtime
      end

      #
      # Returns +true+ if the mtime of the object-file path is newer than
      # the object-files mtime, returns +false+ otherwise.
      #
      def is_stale?
        File.mtime(@path)!=@mtime
      end

      #
      # Returns +true+ if the object-files +path+ no longer exists as a
      # file, returns +false+ otherwise.
      #
      def is_missing?
        !(File.file?(@path))
      end

      #
      # Cache the object file within the object-cache. If a _block_ is
      # given, it will be passed the object-file after it has been saved
      # to the object-cache. The cached object file will be returned.
      #
      #   obj_file.cache # => ObjectFile
      #
      #   obj_file.cache do |file|
      #     puts file.mtime
      #   end
      #
      def cache(&block)
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

        block.call(self) if block
        return self
      end

      #
      # Updates the object-file within the object-cache, only if the
      # object-file is stale. If a _block_ is given, it will be passed the
      # updated object-file, only the object-file is updated. The
      # object-file will be returned.
      #
      def update(&block)
        cache(&block) if is_stale?
        return self
      end

      #
      # Removes the associated object-contexts of the object-file from the
      # object-cache. If a _block_ is given, it will be passed the object-
      # file before it is object-contexts are cleaned from the object-cache.
      # The cleaned object-file will be returned.
      #
      #   obj_file.clean # => ObjectFile
      #
      #   obj_file.clean do |file|
      #     puts file.path
      #   end
      #
      def clean(&block)
        block.call(self) if block

        @contexts.each do |context|
          if ObjectContext.is_object_context?(context)
            objs = ObjectContext.object_contexts[context].find(:condition => ['object_path = ?', @path])
            objs.each { |obj| obj.delete }
          end
        end

        # clear the contexts list
        @contexts.clear

        return self
      end

      #
      # Cleans and removes the object-file from the object-cache. The
      # expunged object-file will be returned.
      #
      def expunge
        clean
        delete
      end

    end
  end
end
