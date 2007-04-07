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

require 'repo/context'
require 'repo/exceptions/categorynotfound'
require 'repo/objectcontext'
require 'repo/exploitcontext'
require 'repo/platformexploitcontext'
require 'repo/bufferoverflowcontext'
require 'repo/formatstringcontext'
require 'repo/payloadcontext'
require 'repo/config'

module Ronin
  module Repo
    class Category < Context

      # Category control directory
      CONTROL_DIR = 'categories'

      # Category contexts
      attr_reader :contexts

      # Category dependencies
      attr_reader :categories

      def initialize(name)
	if name==CONTROL_DIR
	  raise CategoryNotFound, "invlaid category name '#{name}'", caller
	end
	
	if !config.has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

	@contexts = []
	@categories = []

	super(name,controller_path(name))

	# load similarly named contexts from all repositories
	config.categories[name].each_value do |repository|
	  repository.find_dir(name) do |dir|
	    @contexts << Context.new(name,dir)
	  end
	end
      end

      def has_dependency?(name)
	!(dependency(name).nil?)
      end

      def dependency(name)
	# self is the dependency
	return self if name==@name

	# search categories for the dependency
	@categories.each do |category|
	  dep = category.dependency(name)
	  return dep if dep
	end
	return nil
      end

      def dist(&block)
	# distribute block over self and scopes
	results = Context::dist(&block)

	# distribute block over contexts
	@contexts.each do |context|
	  results.concat(context.dist(&block))
	end

	# distribute block over dependencies
	@categories.each do |category|
	  results.concat(category.dist(&block))
	end
	return results
      end

      def find_path(path,&block)
	paths = dist { find_path(path) }.compact
	if block
	  paths.each { |i| block.call(i) }
	else
	  return paths
	end
      end

      def glob_path(pattern,&block)
	paths = dist { glob_path(path) }.compact
	if block
	  paths.each { |i| block.call(i) }
	else
	  return paths
	end
      end

      def get_action(sym)
	dist { get_action(sym) }.compact
      end

      def perform_action(sym,*args)
	action_list = get_action(sym)
	if action_list.empty?
	  raise ActionNotFound, "action '#{sym}' was not found in category '#{self}'", caller
	end

	# map actions to results
	return action_list.map { |act| act.call(*args) }
      end

      def to_s
	@name
      end

      protected

      # Name of context to load
      attr_context :category

      def controller_path(name)
	config.categories[name].each_value do |repository|
	  repository.find_dir?(File.join(CONTROL_DIR,name)) do |dir|
	    return dir
	  end
	end

	raise CategoryNotFound, "controller for category '#{name}' not found", caller
      end

      def depend(name)
	if name==CONTROL_DIR
	  raise CategoryNotFound, "invlaid category name '#{name}'", caller
	end
	
	if !config.has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

	# return existing dependency
	category = dependency(name)
	return category if category

	# add new dependency
	category = Category.new(name)
	@categories << category
	return category
      end

      def method_missing(sym,*args)
	name = sym.id2name

	# resolve dependencies
	dep = dependency(name)
	return dep if dep

	# resolve scopes
	sub_scope = scope(name)
	return sub_scope if sub_scope

	# resolve actions
	return perform_action(sym,*args)
      end

    end
  end
end
