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

require 'repo/fileaccess'
require 'repo/exceptions/actionnotfound'
require 'repo/exceptions/contextnotfound'
require 'repo/exceptions/objectnotfound'

module Ronin
  module Repo
    class Context

      include FileAccess

      # Name of context
      attr_reader :name

      # Working directory of the context
      attr_reader :path

      # Scopes of the context
      attr_reader :context_deps

      def initialize(name,path)
	@name = name
	@path = path
	@actions = {}
	@context_deps = []

	# load context file if it exists
	file = File.join(@path,@name,'.rb')
	if File.file?(file)
	  load(file)

	  # evaluate the context block if present
	  class_eval(get_context(context_type)) if has_context?(context_type)
	end
      end

      def get_action(sym)
	return @actions[name] if @actions.has_key?(name)

	@context_deps.each do |scope|
	  action = scope.get_action(sym)
	  return action if action
	end
	return nil
      end

      def has_action?(sym)
	!(get_action(sym).nil?)
      end

      def perform_action(sym,*args)
	action = get_action(sym)
	unless action
	  raise ActionNotFound, "cannot find action '#{sym}' in group '#{self}'", caller
	end

	return action.call(*args)
      end

      def perform_setup
	perform_action(:setup)
      end

      def perform_teardown
	perform_action(:teardown)
      end

      def has_scope?(name)
	!(scope(name).nil?)
      end

      def context(name)
	# self is the scope
	return self if name==@name

	# search context dependencies
	@context_deps.each do |sub_context|
	  search_context = sub_context.context(name)
	  return search_scope if search_scope
	end
	return nil
      end

      def context_eval(name=@name,&block)
	sub_context = context(name)
	unless sub_context
	  raise ContextNotFound, "sub-context '#{name}' not found within context '#{@name}'", caller
	end

	return sub_context.instance_eval(&block)
      end

      def dist(&block)
	# evaluate block within self
	results = [instance_eval(&block)]

	# distribute block within context dependencies
	@context_deps.each do |sub_context|
	  results.concat(sub_context.dist(&block))
	end
	return results
      end

      def find_local_path(path,&block)
	find_path(path,&block)
      end

      def find_local_file(path,&block)
	find_file(path,&block)
      end

      def find_local_dir(path,&block)
	find_dir(path,&block)
      end

      def glob_local_paths(pattern,&block)
	glob_paths(patter,&block)
      end

      def glob_local_files(pattern,&block)
	glob_files(pattern,&block)
      end

      def glob_local_dirs(pattern,&block)
	glob_dirs(pattern,&block)
      end

      def all_local_paths(&block)
	all_paths(&block)
      end

      def all_local_files(&block)
	all_files(&block)
      end

      def all_local_dirs(&block)
	all_dirs(&block)
      end

      def local_load(path)
	ronin_load(path)
      end

      def local_require(path)
	ronin_require(path)
      end

      def has_local_path?(path,&block)
	has_path?(path,&block)
      end

      def has_local_file?(path,&block)
	has_file?(path,&block)
      end

      def has_local_dir?(path,&block)
	has_dir?(path,&block)
      end

      def to_s
	@name
      end

      protected

      def Context.attr_context(*id)
	# define context_type
	class_eval <<-"end_eval"
	  def context_type
	    :#{id}
	  end
	end_eval

	# define kernel-level context method
	Kernel.module_eval <<-"end_eval"
	  def ronin_#{id}(&block)
	    $context_block[:#{id}] = block
	  end
	end_eval
      end

      def Context.attr_action(*ids)
	for id in ids
	  class_eval <<-"end_eval"
	    def #{id}(&block)
	      action(:#{id},&block)
	    end
	  end_eval
	end
      end

      # Name of context to load
      attr_context :context

      # Setup action
      attr_action :setup
      
      # Teardown action
      attr_action :teardown

      def action(sym,&block)
	@actions[sym] = Action.new(sym,self,&block)
      end

      def inherit(path)
	find_path(path) do |file|
	  if File.file?(file)
	    name = File.basename(file,'.rb')
	    wd = File.dirname(file)
	  elsif File.directory?(file)
	    name = File.basename(dir)
	    wd = dir
	  end

	  new_context = context(name)
	  return new_context if new_context

	  new_context = Context.new(name,wd)
	  @context_deps << new_context
	  return new_context
	end

	raise ContextNotFound, "context '#{path}' does not exist", caller
      end

      def method_missing(sym,*args)
	# resolve contexts
	sub_context = context(sym.id2name)
	return sub_context if sub_context

	# resolve actions
	return perform_action(sym,*args)
      end

      private

      def has_context?(sym)
	!($context_block[sym].nil?)
      end

      def get_context(sym)
	block = $context_block[sym]
	$context_block[sym] = nil
	return block
      end

    end

    protected

    # Context block hash
    $context_block = {}
  end
end
