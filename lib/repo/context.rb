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

      # Context actions
      attr_reader :actions

      # Scopes of the context
      attr_reader :context_deps

      def initialize(context_path)
	@name = File.basename(context_path,'.rb')
	@path = File.dirname(context_path)
	@actions = {}
	@context_deps = []

	if File.file?(context_path)
	  load(context_path)

	  # evaluate the context block if present
	  instance_eval(get_context_block) if has_context_block?
	end
      end

      def has_action?(name)
	name = name.to_s

	return true if @actions.has_key?(name)

	@context_deps.each do |sub_context|
	  return true if sub_context.has_action?(name)
	end
	return false
      end

      def get_action(name)
	name = name.to_s

	return @actions[name] if @actions.has_key?(name)

	@context_deps.each do |sub_context|
	  action = sub_context.get_action(name)
	  return action if action
	end
	return nil
      end

      def perform_action(name,*args)
	action = get_action(name)
	unless action
	  raise ActionNotFound, "cannot find action '#{name}' in group '#{self}'", caller
	end

	return action.call(*args)
      end

      def setup
	perform_action(:setup)
      end

      def teardown
	perform_action(:teardown)
      end

      def has_context?(name)
	name = name.to_s

	# self is the scope
	return true if name==@name

	# search context dependencies
	@context_deps.each do |sub_context|
	  return true if sub_context.has_context?(name)
	end
	return false
      end

      def context(name)
	name = name.to_s

	# self is the scope
	return self if name==@name

	# search context dependencies
	@context_deps.each do |sub_context|
	  search_context = sub_context.context(name)
	  return search_context if search_context
	end
	return nil
      end

      def context_eval(name=@name,&block)
	name = name.to_s

	sub_context = context(name)
	unless sub_context
	  raise ContextNotFound, "sub-context '#{name}' not found within context '#{@name}'", caller
	end

	return sub_context.instance_eval(&block)
      end

      def dist(&block)
	# distribute block over self
	result = [instance_eval(&block)]

	# distribute block over context dependencies
	return result + @context_deps.map { |sub_context| sub_context.dist(&block) }
      end

      def local_path(path,&block)
	find_path(path,&block)
      end

      def local_file(path,&block)
	find_file(path,&block)
      end

      def local_dir(path,&block)
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

      def Context.attr_context(id)
	# define context_type
	class_eval <<-"end_eval"
	  def context_name
	    '#{id}'
	  end
	end_eval

	# define kernel-level context method
	Kernel::module_eval <<-"end_eval"
	  def ronin_#{id}(&block)
	    $context_block['#{id}'] = block
	  end
	end_eval

	Ronin::module_eval <<-"end_eval"
	  def ronin_load_#{id}(path,&block)
	    obj = #{self.name}.new(path)
	    if block
	      obj.setup
	      v = block.call(obj)
	      obj.teardown
	      return v
	    else
	      return obj
	    end
	  end
	end_eval
      end

      def Context.attr_action(*ids)
	for id in ids
	  class_eval <<-"end_eval"
	    def action_#{id}(&block)
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

      def action(name,&block)
	@actions[name.to_s] = Action.new(name,self,&block)
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
	name = sym.id2name

	# resolve contexts
	sub_context = context(name)
	return sub_context if sub_context

	# resolve actions
	return perform_action(name,*args) if has_action?(name)

	raise NoMethodError.new(name)
      end

      private

      def has_context_block?
	!($context_block[context_name].nil?)
      end

      def get_context_block
	block = $context_block[context_name]
	$context_block[context_name] = nil
	return block
      end

    end

    private

    # Context block hash
    $context_block = {}
  end
end
