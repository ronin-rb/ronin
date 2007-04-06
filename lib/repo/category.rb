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
require 'repo/config'
require 'repo/objectcontext'
require 'repo/exploitcontext'
require 'repo/platformexploitcontext'
require 'repo/bufferoverflowcontext'
require 'repo/formatstringcontext'
require 'repo/payloadcontext'

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

	super(name,find_controller(name))

	config.categories[name].each_value do |repository|
	  repository.find_dir(name) do |dir|
	    @contexts << Context.new(name,dir)
	  end
	end
      end

      def has_dependency?(name)
	return true if name==@name

	@categories.each do |category|
	  return true if category.has_dependency?(name)
	end
	return false
      end

      def dependency(name)
	return self if name==@name

	@categories.each do |category|
	  return category.dependency(name) if category.has_dependency?(name)
	end
	return nil
      end

      def distribute(&block)
	results = [Context::instance_eval(&block)]

	@contexts.each do |context|
	  results << context.instance_eval(&block)
	end

	@categories.each do |context|
	  results << context.distribute(&block)
	end

	return results.flatten.reject { |item| item.nil? }
      end

      def find_path(path,&block)
	paths = distribute { find_path(path) }
	if block
	  paths.each { |i| block.call(i) }
	else
	  return paths
	end
      end

      def glob_path(pattern,&block)
	paths = distribute { glob_path(path) }
	if block
	  paths.each { |i| block.call(i) }
	else
	  return paths
	end
      end

      def to_s
	return @name
      end

      protected

      def find_controller(name)
	config.categories[name].each_value do |repository|
	  repository.find_dir?(File.join(CONTROL_DIR,name)) do |dir|
	    return dir
	  end
	end

	raise CategoryNotFound, "category controller for category '#{name}' not found", caller
      end

      def depend(name)
	if name==CONTROL_DIR
	  raise CategoryNotFound, "invlaid category name '#{name}'", caller
	end
	
	if !config.has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

	if has_scope?(name)
	  return false
	else
	  new_category = Category.new(name)
	  @categories << new_category
	  @scope << new_category
	  return true
	end
      end

      def method_missing(sym,*args)
	name = sym.id2name

	# Resolve scopes
	return scope(name) if has_scope?(name)

	# Perform top-level action first
	perform_action(sym,*args) if has_action?(sym)

	# Perform context actions as well
	@contexts.each do |context|
	  context.perform_action(sym,*args) if context.has_action?(sym)
	end
      end

    end
  end
end
