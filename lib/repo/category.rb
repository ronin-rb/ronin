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
require 'repo/object'
require 'repo/exploits/exploit'
require 'repo/exploits/platformexploit'
require 'repo/exploits/bufferoverflow'
require 'repo/exploits/formatstring'
require 'repo/exploits/webexploit'
require 'repo/payloads/payload'
require 'repo/payloads/platformpayload'
require 'repo/cache'

module Ronin
  module Repo
    class Category < Context

      # Category dependencies
      attr_reader :categories

      # Name of context to load
      attr_context :category

      # Main action
      attr_action :main

      def initialize(name)
	unless cache.has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

	super(name)

	@categoryies = []

	# union all similar categories together
	cache.categories[name].each_value do |repository|
	  repository.find_dir(name) do |dir|
	    union!(File.join(dir,name+'.rb'))
	  end
	end
      end

      def depend(name)
	name = name.to_s

	unless cache.has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

	# return existing category
	new_category = category(name)
	return new_category if new_category

	# add new category
	new_category = Category.new(name)
	@categories << new_category
	return new_category
      end

      def has_category?(name)
	name = name.to_s

	# self is the category
	return true if name==@name

	# search category dependencies for the category
	@categories.each do |sub_category|
	  return true if sub_category.has_category?(name)
	end
	return false
      end

      def category(name)
	name = name.to_s

	# self is the category
	return self if name==@name

	# search category dependencies for the category
	@categories.each do |sub_category|
	  dep = sub_category.category(name)
	  return dep if dep
	end
	return nil
      end

      def category_eval(name=@name,&block)
	name = name.to_s

	sub_category = category(name)
	unless sub_category
	  raise CategoryNotFound, "category '#{name}' not found within category '#{@name}'", caller
	end

	return sub_category.instance_eval(&block)
      end

      def dist(&block)
	# distribute block over self and context dependencies
	results = Context::dist(&block)

	# distribute block over category dependencies
	results += @categories.map { |sub_category| sub_category.dist(&block) }

	return results
      end

      def has_action?(name)
	name = name.to_s

	return true if Context::has_key?(name)

	@categories.each do |sub_category|
	  return true if sub_category.has_action?(name)
	end
	return false
      end

      def get_action(name)
	name = name.to_s

	context_action = Context::get_action(name)
	return context_action if context_action

	@categories.each do |sub_category|
	  category_action = sub_category.get_action(name)
	  return category_action if category_action
	end
	return nil
      end

      def main
	perform_action(:main)
      end

      protected

      def method_missing(sym,*args)
	name = sym.id2name

	# resolve dependencies
	dep = category(name)
	return dep if dep

	return Context::send(sym,*args)
      end

    end
  end
end
