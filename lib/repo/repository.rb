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

require 'config'
require 'repo/cache'
require 'repo/repositorymetadata'
require 'repo/application'
require 'repo/exceptions/applicationnotfound'

module Ronin
  module Repo
    class Repository < RepositoryMetadata

      # Path to repositories dir
      REPOS_PATH = File.join(Config::PATH,'repos')

      # Local path to the repository
      attr_reader :path

      # Local path to the repository metadata
      attr_reader :metadata_path

      def initialize(path)
	@path = File.expand_path(path)
	@metadata_path = File.join(@path,RepositoryMetadata::METADATA_FILE)

	super(@metadata_path)
      end

      def is_resolved?
	@deps.each_key do |dep|
	  return false unless cache.has_repository?(dep)
	end
	return true
      end

      def resolve
	@deps.each do |key,value|
	  unless cache.has_repository?(key)
	    cache.install(RespositoryMetadata.new(value))
	  end
	end
      end

      def install
	cache.register_repository(self) do
	  resolve unless is_resolved?
	  cache.dump
	end
      end

      def update
	update_cmd = lambda do |cmd,*args|
	  unless system(cmd,*args)
	    raise "failed to update repository '#{self}'", caller
	  end
	end

	cache_applications do
	  case @type
	  when 'svn' then
	    update_cmd.call('svn','up',@path.to_s)
	  when 'cvs' then
	    update_cmd.call('cvs','update','-dP',@path.to_s)
	  when 'rsync' then
	    update_cmd.call('rsync','-av','--delete-after','--progress',@src.to_s,@path.to_s)
	  end
	end

	update_metadata(@metadata_path)
      end

      def commit
	commit_cmd = lambda do |cmd,*args|
	  unless system(cmd,*args)
	    raise "failed to commit changes for repository '#{self}'", caller
	  end
	end

	cache_applications do
	  case @type
	  when 'svn' then
	    commit_cmd.call('svn','commit',@path.to_s)
	  when 'cvs' then
	    commit_cmd.call('cvs','commit',@path.to_s)
	  when 'rsync' then
	    commit_cmd.call('rsync','-av','--delete-after','--progress',@path.to_s,@src.to_s)
	  end
	end
      end

      def has_application?(name)
	@applications.include?(name.to_s)
      end

      def to_s
	@name
      end

    end
  end
end
