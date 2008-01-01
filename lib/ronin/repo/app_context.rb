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

require 'ronin/repo/context'

module Ronin
  module Repo
    class AppContext

      include Context

      # Name of context
      attr_accessor :name

      # Path of context
      attr_accessor :path

      # Parent Application
      attr_accessor :application

      contextify :application

      def initialize(path,application=nil)
        path = File.expand_path(path)

        unless File.exists?(path)
          raise(AppContextNotFound,"application context '#{path}' does not exist",caller)
        end

        @name = File.basename(path)
        @path = path
        @application = application

        $LOAD_PATH.unshift(@path) unless $LOAD_PATH.include?(@path)
      end

      def self.load_context_from(path,application=nil)
        unless File.exists?(path)
          raise(AppContextNotFound,"application context '#{path}' does not exist",caller)
        end

        unless File.directory?(path)
          raise(AppContextNotFound,"application context '#{path}' is not a directory",caller)
        end

        # create a new AppContext
        new_appcontext = self.new(path,application)

        # load the context file if present
        appcontext_path = File.join(path,'app.rb')
        new_appcontext.load_context(appcontext_path) if File.file?(appcontext_path)

        return new_appcontext
      end

      def provides_method?(name)
        public_methods.include?(name.to_s)
      end

      def distribute(&block)
        if @application
          return @application.distribute(&block)
        else
          return []
        end
      end

      def distribute_call(sym,*args,&block)
      end

      def distribute_once(sym,*args,&block)
        if @application
          @application.distribute_once(sym,*args,&block)
        else
          raise(NoMethodError,sym.id2name,caller)
        end
      end

      def find_path(path,&block)
        full_path = File.expand_path(File.join(@path,path))

        if File.exists?(full_path)
          block.call(full_path) if block
          return full_path
        end
      end

      def find_file(path,&block)
        full_path = File.expand_path(File.join(@path,path))

        if File.file?(full_path)
          block.call(full_path) if block
          return full_path
        end
      end

      def find_dir(path,&block)
        full_path = File.expand_path(File.join(@path,path))

        if File.directory?(full_path)
          block.call(full_path) if block
          return full_path
        end
      end

      def glob_paths(pattern,&block)
        full_paths = Dir.glob(File.join(@path,pattern))

        full_paths.each(&block) if block
        return full_paths
      end

      def glob_files(pattern,&block)
        glob_paths(pattern).select do |path|
          File.file?(path)
        end

        full_paths.each(&block) if block
        return full_paths
      end

      def glob_dirs(pattern,&block)
        glob_paths(pattern).select do |path|
          File.directory?(path)
        end

        full_paths.each(&block) if block
        return full_paths
      end

      def to_s
        @name.to_s
      end

      protected

      def Object.distribute(id,dist_id="#{id}s")
        class_eval %{
          def #{dist_id}(*args,&block)
            distribute_call(:#{id},*args,&block).compact
          end
        }
      end

      distribute :find_path
      distribute :find_file
      distribute :find_dir
      distribute :glob_paths, :glob_all_paths
      distribute :glob_files, :glob_all_files
      distribute :glob_dirs, :glob_all_dirs

      def method_missing(sym,*args,&block)
        @application.send(sym,*args,&block) if @application
      end

    end
  end
end
