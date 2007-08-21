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

require 'ronin/repo/context'
require 'ronin/repo/exceptions/applicationnotfound'
require 'ronin/repo/cache'
require 'ronin/objectcache'

module Ronin
  module Repo
    class Application < Context

      # Name of the context to load
      context :app

      # Main action
      attr_action :main

      # Applications dependencies
      attr_reader :dependencies

      def initialize(name=context_name,&block)
        @dependencies = {}
        @cache_paths = []

        super(name,&block)
      end

      def self.create(name,&block)
        new_app = self.new(name)

        # merge all similar applications together
        Repo.cache.applications[name].each_value do |repo|
          app_dir = File.join(repo.path,name)
          if File.directory?(app_dir)
            $LOAD_PATH.unshift(repo.path) unless $LOAD_PATH.include?(repo.path)

            new_app.merge!(File.join(app_dir,'app.rb'))
          end
        end

        block.call(new_app) if block
        return new_app
      end

      def depend(name,&block)
        name = name.to_s

        # return existing application
        new_app = application(name)
        return new_app if new_app

        # add new application
        new_app = self.create(name,&block)
        @dependencies[new_app.name] = new_app
        return new_app
      end

      def has_application?(name)
        name = name.to_s

        # self is the application
        return true if name==@name

        # search application dependencies for the application
        @dependencies.each_value do |sub_app|
          return true if sub_app.has_application?(name)
        end
        return false
      end

      def application(name)
        name = name.to_s

        # self is the application
        return self if name==@name

        # search application dependencies for the application
        @dependencies.each_value do |sub_app|
          if (dep = sub_app.application(name))
            return dep
          end
        end
        return nil
      end

      def application_eval(name=@name,&block)
        name = name.to_s

        sub_app = application(name)
        unless sub_app
          raise(CategoryNotFound,"application '#{name}' not found within application '#{@name}'",caller)
        end

        return sub_app.instance_eval(&block)
      end

      def dist(&block)
        # distribute block over self and context dependencies
        results = super(&block)

        # distribute block over application dependencies
        results += @dependencies.values.map { |sub_app| sub_app.dist(&block) }

        return results
      end

      def has_action?(name)
        name = name.to_s

        return true if super(name)

        @dependencies.each_value do |sub_app|
          return true if sub_app.has_action?(name)
        end
        return false
      end

      def get_action(name)
        name = name.to_s

        if (context_action = super(name))
          return context_action
        end

        @dependencies.each_value do |sub_app|
          app_action = sub_app.get_action(name)
          return app_action if app_action
        end
        return nil
      end

      def setup
        @cache_paths.each do |path|
          path = File.expand_path(path)

          obj_file = ObjectFile.find_by_path(path)
          if obj_file
            obj_file.update
          else
            ObjectFile.timestamp(@name,path)
          end
        end

        obj_files = ObjectFile.find_all_by_application(@name)
        obj_files.each do |obj_file|
          obj_file.expunge if obj_file.is_missing?
        end

        dist do
          return unless has_action?(:setup)
          return perform_action(:setup)
        end
      end

      def main(args=[])
        dist do
          return unless has_action?(:main)
          return perform_action(:main,args)
        end
      end

      protected

      def cache(*paths)
        @cache_paths += paths
      end

      def method_missing(sym,*args)
        name = sym.id2name

        # resolve dependencies
        sub_app = application(name)
        return sub_app if sub_app

        # perform action
        return perform_action(sym,*args) if has_action?(name)

        raise(NoMethodError,name)
      end

    end
  end
end
