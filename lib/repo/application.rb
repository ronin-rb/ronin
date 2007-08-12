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
require 'repo/cache'

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

	super(name,&block)
      end

      def self.create(name,&block)
	new_category = self.new(name)

	# merge all similar applications together
	Repo.cache.applications[name].each_value do |repository|
	  category_dir = File.join(repository.path,name)
	  if File.directory?(category_dir)
	    new_category.merge!(File.join(category_dir,'app.rb'))
	  end
	end

	block.call(new_category) if block
	return new_category
      end

      def depend(name)
	name = name.to_s

	# return existing category
	new_category = category(name)
	return new_category if new_category

	# add new category
	new_category = self.new(name)
	@dependencies[new_category.name] = new_category
	return new_category
      end

      def has_category?(name)
	name = name.to_s

	# self is the category
	return true if name==@name

	# search category dependencies for the category
	@dependencies.each_value do |sub_category|
	  return true if sub_category.has_category?(name)
	end
	return false
      end

      def category(name)
	name = name.to_s

	# self is the category
	return self if name==@name

	# search category dependencies for the category
	@dependencies.each_value do |sub_category|
	  if (dep = sub_category.category(name))
	    return dep
	  end
	end
	return nil
      end

      def category_eval(name=@name,&block)
	name = name.to_s

	unless (sub_category = category(name))
	  raise CategoryNotFound, "category '#{name}' not found within category '#{@name}'", caller
	end

	return sub_category.instance_eval(&block)
      end

      def dist(&block)
	# distribute block over self and context dependencies
	results = super(&block)

	# distribute block over category dependencies
	results += @dependencies.values.map { |sub_category| sub_category.dist(&block) }

	return results
      end

      def has_action?(name)
	name = name.to_s

	return true if super(name)

	@dependencies.each_value do |sub_category|
	  return true if sub_category.has_action?(name)
	end
	return false
      end

      def get_action(name)
	name = name.to_s

	if (context_action = super(name))
	  return context_action
	end

	@dependencies.each_value do |sub_category|
	  category_action = sub_category.get_action(name)
	  return category_action if category_action
	end
	return nil
      end

      def main(args=[])
	dist {
	  return unless has_action?(:main)
	  return perform_action(:main,args)
	}
      end

      protected

      def method_missing(sym,*args)
	name = sym.id2name

	# resolve dependencies
	if (sub_category = category(name))
	  return sub_category
	end

	# perform action
	return perform_action(sym,*args) if has_action?(name)

	raise NoMethodError.new(name)
      end

    end
  end
end
