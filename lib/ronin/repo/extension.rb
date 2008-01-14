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

require 'ronin/repo/context'
require 'ronin/repo/exceptions/extension_not_found'
require 'ronin/repo/repo'

module Ronin
  module Repo
    class Extension

      # Name of the extension
      attr_reader :name

      # Extension dependencies
      attr_reader :dependencies

      # Extension contexts
      attr_reader :contexts

      #
      # Create a new Extension object with the specified _name_. If
      # _block_ is given, it will be passed the newly created Extension
      # object.
      #
      def initialize(name,&block)
        @name = name
        @dependencies = {}
        @contexts = []

        # load all related extension contexts
        Repo.cache.repositories_with_extension(name) do |repo|
          @contexts << repo.extension_context(name,self)
        end

        block.call(self) if block
      end

      def depend(name)
        name = name.to_s

        # return existing dependency
        if (dep = dependency(name))
          return dep
        end

        # add the new dependency
        return @dependencies[name] = Extension.new(name)
      end

      #
      # Returns the extension dependency with the matching _name_.
      #
      def dependency(name)
        name = name.to_s

        return self if @name==name

        @dependencies.each do |ext|
          dep = ext.dependency(name)
          return dep if dep
        end

        return nil
      end

      #
      # Returns true if the extension depends on the extension with
      # the matching _name_, returns false otherwise.
      #
      def depends_on?(name)
        !(dependency(name).nil?)
      end

      def contexts_with(&block)
        matches = @contexts.select(&block)

        @dependencies.each_value do |ext|
          matches += ext.contexts_with(&block)
        end

        return matches
      end

      def context_with(&block)
        if (match = @context.select(&block).first)
          return match
        end

        @dependencies.each_value do |ext|
          if (match = ext.context_with(&block))
            return match
          end
        end

        return nil
      end

      def distribute(&block)
        results = @contexts.map(&block)

        @dependencies.each_value do |ext|
          results += ext.distribute(&block)
        end

        return results
      end

      def distribute_call(sym,*args,&block)
        name = sym.to_s

        # collect contexts
        contexts = contexts_with do |context|
          context.provides_method?(name)
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
          ext.provides_method?(name)
        end

        unless context
          raise(NoMethodError,name,caller)
        end

        return context.send(sym.to_sym,*args,&block)
      end

      def setup
        distribute_call(:setup)
        return self
      end

      def command(args)
        distribute_call(:command,args)
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
