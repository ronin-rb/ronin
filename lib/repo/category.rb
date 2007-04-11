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
      attr_reader :category_deps

      def initialize(name)
	if name==CONTROL_DIR
	  raise CategoryNotFound, "invlaid category name '#{name}'", caller
	end
	
	if !config.has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

	@contexts = []
	@category_deps = []

	super(name,controller_path(name))

	# load similarly named contexts from all repositories
	config.categories[name].each_value do |repository|
	  repository.find_dir(name) do |dir|
	    @contexts << Context.new(name,dir)
	  end
	end
      end

      def has_category?(name)
	!(category(name).nil?)
      end

      def category(name)
	# self is the category
	return self if name==@name

	# search category dependencies for the category
	@category_deps.each do |sub_category|
	  dep = sub_category.category(name)
	  return dep if dep
	end
	return nil
      end

      def category_eval(name=@name,&block)
	sub_category = category(name)
	unless sub_category
	  raise CategoryNotFound, "sub-category '#{name}' not found within category '#{@name}'", caller
	end

	return sub_category.instance_eval(&block)
      end

      def dist(&block)
	# distribute block over self and context dependencies
	results = Context::dist(&block)

	# distribute block over contexts
	@contexts.each do |context|
	  results.concat(context.dist(&block))
	end

	# distribute block over category dependencies
	@category_deps.each do |category|
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

      def glob_paths(pattern,&block)
	paths = dist { glob_path(path) }.compact
	if block
	  paths.each { |i| block.call(i) }
	else
	  return paths
	end
      end

      def find_local_path(path,&block)
	Context::find_path(path,&block)
      end

      def find_local_file(path,&block)
	Context::find_file(path,&block)
      end

      def find_local_dir(path,&block)
	Context::find_dir(path,&block)
      end

      def glob_local_paths(pattern,&block)
	Context::glob_paths(patter,&block)
      end

      def glob_local_files(pattern,&block)
	Context::glob_files(pattern,&block)
      end

      def glob_local_dirs(pattern,&block)
	Context::glob_dirs(pattern,&block)
      end

      def all_local_paths(&block)
	Context::all_paths(&block)
      end

      def all_local_files(&block)
	Context::all_files(&block)
      end

      def all_local_dirs(&block)
	Context::all_dirs(&block)
      end

      def local_load(path)
	Context::ronin_load(path)
      end

      def local_require(path)
	Context::ronin_require(path)
      end

      def has_local_path?(path,&block)
	Context::has_path?(path,&block)
      end

      def has_local_file?(path,&block)
	Context::has_file?(path,&block)
      end

      def has_local_dir?(path,&block)
	Context::has_dir?(path,&block)
      end

      def get_action(id)
	dist { get_action(id.to_s) }.compact
      end

      def perform_action(id,*args)
	name = id.to_s
	action_list = get_action(name)

	if action_list.empty?
	  raise ActionNotFound, "action '#{name}' was not found in category '#{self}'", caller
	end

	# map actions to results
	return action_list.map { |act| act.call(*args) }
      end

      def main
	perform_action('main')
      end

      def to_s
	@name
      end

      protected

      # Name of context to load
      attr_context :category

      # Main action
      attr_action :main

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

	# return existing category
	new_category = category(name)
	return new_category if new_category

	# add new category
	new_category = Category.new(name)
	@category_deps << new_category
	return new_category
      end

      def method_missing(sym,*args)
	name = sym.id2name

	# resolve dependencies
	dep = category(name)
	return dep if dep

	# resolve contexts
	sub_context = context(name)
	return sub_context if sub_context

	# resolve actions
	return perform_action(name,*args)
      end

    end
  end
end
