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

require 'ronin/config'
require 'ronin/repo/cache'
require 'ronin/repo/repositorymetadata'
require 'ronin/repo/application'
require 'ronin/repo/exceptions/applicationnotfound'

module Ronin
  module Repo
    class Repository < RepositoryMetadata

      # Path to repositories dir
      REPOS_PATH = File.join(Config::PATH,'repos')

      # Filename of the repository metadata XML document
      METADATA_FILE = 'ronin.xml'

      # Local path to the repository
      attr_reader :path

      def initialize(path)
        @path = File.expand_path(path)

        super(File.join(@path,METADATA_FILE))
      end

      def self.install(path)
        self.new(path).install
      end

      def dependencies_resolved?
        @deps.each_key do |dep|
          return false unless cache.has_repository?(dep)
        end

        return true
      end

      def resolve_dependencies
        @deps.each do |key,value|
          unless cache.has_repository?(key)
            cache.install(RespositoryMetadata.new(value))
          end
        end

        return self
      end

      def install
        cache.add_repository(self) do
          resolve_dependencies unless dependencies_resolved?
          cache.save
        end
      end

      def update
        update_cmd = lambda do |cmd,*args|
          unless system(cmd,*args)
            raise("failed to update repository '#{self}'",caller)
          end
        end

        case @type
        when :svn then
          update_cmd.call('svn','up',@path.to_s)
        when :cvs then
          update_cmd.call('cvs','update','-dP',@path.to_s)
        when :rsync then
          update_cmd.call('rsync','-av','--delete-after','--progress',@src.to_s,@path.to_s)
        end

        # reload repository metadata
        load_metadata(@metadata_path)

        return self
      end

      def commit
        commit_cmd = lambda do |cmd,*args|
          unless system(cmd,*args)
            raise("failed to commit changes for repository '#{self}'",caller)
          end
        end

        case @type
        when :svn then
          commit_cmd.call('svn','commit',@path.to_s)
        when :cvs then
          commit_cmd.call('cvs','commit',@path.to_s)
        when :rsync then
          commit_cmd.call('rsync','-av','--delete-after','--progress',@path.to_s,@src.to_s)
        end

        return self
      end

      def applications
        Dir.new(@path).grep(/^[^.]/).select { |file| File.directory?(file) }
      end

      def has_application?(name)
        unless valid_application?(name)
          raise(ApplicationNotFound,"application '#{name}' does not have a valid application name",caller)
        end

        return File.directory?(File.join(@path,name))
      end

      def app_context(name,application=nil)
        unless has_application?(name)
          raise(ApplicationNotfound,"repository '#{@name}' does not contain the application '#{name}'",caller)
        end

        AppContext.load_context_from(File.join(@path,name))
      end

      protected

      def valid_application?(name)
        return !(name.to_s[/(^.|..|\/)/])
      end

    end
  end
end
