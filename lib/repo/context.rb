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

require 'repo/extensions/kernel'
require 'repo/exceptions/contextnotfound'
require 'repo/exceptions/actionnotfound'

module Ronin
  module Repo
    class Context

      # Name of context
      attr_reader :name

      # Working directories of the context
      attr_reader :paths

      # Context actions
      attr_reader :actions

      # Sub-contexts inherited by the context
      attr_reader :contexts

      def initialize(name='')
	@name = name
	@paths = []
	@actions = {}
	@contexts = []
      end

      def Context.create(path,&block)
	new_context = Context.new(File.basename(path,'.rb'))
	new_context.import(path)

	block.call(new_context) if block
	return new_context
      end

      def import(path)
	unless File.file?(path)
	  raise ContextNotFound, "context '#{path}' does not exist", caller
	end

	load(path)

	# add parent directory to paths array
	wd = File.dirname(File.expand_path(path))
	@paths << wd unless @paths.include?(wd)

	# evaluate the context block if present
	instance_eval(&get_context_block) if has_context_block?

	# return the newly imported context
	return self
      end

      def union(other_context)
	# return the unioned copy of this context
	return self.clone.union!(other_context)
      end

      def union!(other_context)
	other_context.paths do |path|
	  @paths << path unless @paths.include?(path)
	end

	@actions.merge!(other_context.actions)

	other_context.contexts do |sub_context|
	  @contexts << sub_context unless @contexts.include?(sub_context)
	end

	return self
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

      def has_context?(name)
	name = name.to_s

	# self is the scope
	return true if name==@name

	# search context dependencies
	@contexts.each do |sub_context|
	  return true if sub_context.has_context?(name)
	end
	return false
      end

      def context(name)
	name = name.to_s

	# self is the scope
	return self if name==@name

	# search context dependencies
	@contexts.each do |sub_context|
	  search_context = sub_context.context(name)
	  return search_context if search_context
	end
	return nil
      end

      def context_eval(name=@name,&block)
	name = name.to_s

	sub_context = context(name)
	unless sub_context
	  raise ContextNotFound, "context '#{name}' not found within context '#{@name}'", caller
	end

	return sub_context.instance_eval(&block)
      end

      def dist(&block)
	# distribute block over self
	result = [instance_eval(&block)]

	# distribute block over context dependencies
	return result + @contexts.map { |sub_context| sub_context.dist(&block) }
      end

      def action(name,&block)
	@actions[name.to_s] = block
      end

      def has_action?(name)
	name = name.to_s

	return true if @actions.has_key?(name)

	@contexts.each do |sub_context|
	  return true if sub_context.has_action?(name)
	end
	return false
      end

      def get_action(name)
	name = name.to_s

	return @actions[name] if @actions.has_key?(name)

	@contexts.each do |sub_context|
	  action = sub_context.get_action(name)
	  return action if action
	end
	return nil
      end

      def perform_action(name,*args)
	action = get_action(name)
	unless action
	  raise ActionNotFound, "cannot find action '#{name}' in context '#{self}'", caller
	end

	return action.call(*args)
      end

      def setup
	return unless has_action?(:setup)
	return perform_action(:setup)
      end

      def teardown
	return unless has_action?(:teardown)
	return perform_action(:teardown)
      end

      def find_path(path,&block)
	@paths.each do |scope_path|
	  real_path = File.join(scope_path,path)

	  if File.exists?(real_path)
	    return block.call(real_path) if block
	    return real_path
	  end
	end
      end

      def find_file(path,&block)
	if block
	  find_path(path) do |file|
	    block.call(file) if File.file?(file)
	  end
	else
	  find_path(path) do |file|
	    return file if File.file?(file)
	  end
	  return nil
	end
      end

      def find_dir(path,&block)
	if block
	  find_path(path) do |dir|
	    block.call(dir) if File.directory?(dir)
	  end
	else
	  find_path(path) do |dir|
	    return dir if File.directory?(dir)
	  end
	  return nil
	end
      end

      def glob_paths(pattern,&block)
	@paths.each do |scope_path|
	  real_paths = Dir.glob(File.join(scope_path,pattern))

	  if block
	    real_paths.each { |path| block.call(path) }
	  else
	    return real_paths
	  end
	end
      end

      def glob_files(pattern,&block)
	if block
	  glob_paths(pattern) do |path|
	    block.call(path) if File.file?(path)
	  end
	else
	  files = []

	  glob_paths(pattern) do |path|
	    files << path if File.file?(path)
	  end
	  return files
	end
      end

      def glob_dirs(pattern,&block)
	if block
	  glob_paths(pattern) do |path|
	    block.call(path) if File.directory?(path)
	  end
	else
	  dirs = []

	  glob_paths(pattern) do |path|
	    dirs << path if File.directory?(path)
	  end
	  return dirs
	end
      end

      def all_paths(&block)
	if block
	  glob_paths('*',&block)
	else
	  return glob_paths('*')
	end
      end

      def all_files(&block)
	if block
	  all_paths do |path|
	    block.call(path) if File.file?(path)
	  end
	else
	  files = []

	  all_paths do |path|
	    files << path if File.file?(path)
	  end
	  return files
	end
      end

      def all_dirs(&block)
	if block
	  all_paths do |path|
	    block.call(path) if File.directory?(path)
	  end
	else
	  dirs = []

	  all_paths do |path|
	    dirs << path if File.directory?(path)
	  end
	  return dirs
	end
      end

      def to_s
	@name
      end

      protected

      def Context.attr_context(id)
	# define context_type
	class_eval <<-"end_eval"
	  def context_id
	    '#{id}'
	  end
	end_eval

	# define kernel-level context method
	Kernel::module_eval <<-"end_eval"
	  def ronin_#{id}(&block)
	    ronin_contexts['#{id}'] = block
	  end
	end_eval

	Ronin::module_eval <<-"end_eval"
	  def ronin_load_#{id}(path,&block)
	    obj = #{self.name}.create(path)
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

      def method_missing(sym,*args)
	name = sym.id2name

	# return sub context
	if (sub_context = context(name))
	  return sub_context
	end

	# perform action
	return perform_action(sym,*args) if has_action?(name)

	raise NoMethodError.new(name)
      end

      private

      def has_context_block?
	!(ronin_contexts[context_id].nil?)
      end

      def get_context_block
	block = ronin_contexts[context_id]
	ronin_contexts[context_id] = nil
	return block
      end

    end

  end
end
