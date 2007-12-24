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
require 'ronin/repo/exceptions/applicationnotfound'
require 'ronin/repo/repo'

module Ronin
  module Repo
    class Application

      # Name of the application
      attr_reader :name

      # Applications dependencies
      attr_reader :dependencies

      # Application Contexts
      attr_reader :contexts

      def initialize(name,&block)
        @name = name
        @dependencies = {}
        @contexts = []

        @cache_paths = []

        # load all related application contexts
        Repo.cache.repositories_with_application(name) do |repo|
          @contexts << repo.appcontext(name,self)
        end

        block.call(self) if block
      end

      def depend(name)
        name = name.to_s

        # return existing dependency
        dep = dependency(name)
        return dep if dep

        # add the new dependency
        @dependencies[name] = Application.new(name)
        return @dependencies[name]
      end

      def dependency(name)
        name = name.to_s

        return self if @name==name

        @dependencies.each do |app|
          dep = app.dependency(name)
          return dep if dep
        end

        return nil
      end

      def depends_on?(name)
        !(dependency(name).nil?)
      end

      def contexts_with(&block)
        matches = @contexts.select(&block)

        @dependencies.each_value do |app|
          matches += app.contexts_with(&block)
        end

        return matches
      end

      def context_with(&block)
        match = @context.select(&block)[0]
        return match if match

        @dependencies.each_value do |app|
          match = app.context_with(&block)
          return match if match
        end

        return nil
      end

      def distribute(&block)
        results = @contexts.map(&block)

        @dependencies.each_value do |app|
          results += app.distribute(&block)
        end

        return results
      end

      def distribute_call(sym,*args,&block)
        name = sym.to_s

        # collect contexts
        contexts = contexts_with do |context|
          context.public_instance_methods(false).include?(name)
        end

        if contexts.empty?
          raise(NoMethodError,name,caller)
        end

        sym = sym.to_sym

        # return distributed return values
        return contexts.map { |context| context.send(sym,*args,&block) }
      end

      def distribute_once(sym,*args,&block)
        name = sym.to_s

        # find the first matching dependency
        context = context_with do |context|
          app.public_instance_methods(false).include?(name)
        end

        unless context
          raise(NoMethodError,name,caller)
        end

        return context.send(sym.to_sym,*args,&block) if context
      end

      def cache(*paths)
        @cache_paths += paths
      end

      def main(args)
        distribute_call(:main,args)
        return self
      end

      def setup
        distribute_call(:setup)
        return self
      end

      def teardown
        distribute_call(:teardown)
        return self
      end

      protected

      def method_missing(sym,*args,&block)
        name = sym.id2name

        if args.length==0
          # resolve dependencies
          dep = dependency(name)

          if dep
            block.call(dep) if block
            return dep
          end
        end

        # distribute the method
        return distribute_once(sym,*args,&block)
      end

    end
  end
end
