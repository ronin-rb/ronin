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

require 'repo/repositorymetadata'
require 'repo/fileaccess'
require 'repo/category'
require 'repo/exceptions/categorynotfound'

module Ronin
  module Repo
    class Repository < RepositoryMetadata

      include FileAccess

      # Local path to the repository
      attr_reader :path

      def initialize(path,&block)
	@path = path
	@categories = []

	Dir.foreach(@path) do |file|
	  if (File.directory?(file) && file!='.' && file!='..' && file!=Category::CONTROL_DIR)
	    @categories << file
	  end
	end

	super(File.join(path,'metadata.xml'),&block)
      end

      def has_category?(name)
	@categories.include?(name.to_s)
      end

      def update
	update_cmd = lambda do |cmd,*args|
	  unless system(cmd,*args)
	    raise "failed to update repository '#{self}'", caller
	  end
	end

        case @type
          when 'svn' then update_cmd.call('svn','up',@path)
          when 'cvs' then update_cmd.call('cvs','update','-dP',@path)
          when 'rsync' then update_cmd.call('rsync','-av','--delete-after','--progress',@src.to_s,@path)
        end
      end

      def to_s
	@name
      end

    end
  end
end
