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

require 'repo/contextable'
require 'repo/exceptions/actionnotfound'

module Ronin
  module Repo
    class Context

      include Contextable

      # Name of context
      attr_reader :name

      # Path of context
      attr_accessor :path

      # Working directories of the context
      attr_accessor :paths

      # Sub-contexts inherited by the context
      attr_reader :contexts

      def initialize(name=context_name,&block)
	@name = name.to_s
	@path = nil
	@paths = []
	@actions = {}
	@contexts = []

	instance_eval(&block) if block
      end

      def self.create(path,&block)
	path = File.expand_path(path)

	new_context = self.new(File.basename(path,'.rb'))
	new_context.merge!(path)

	block.call(new_context) if block
	return new_context
      end

      def merge(path)
	self.clone.merge!(path)
      end

      def merge!(path)
	path = File.expand_path(path)

	# set the initial path of the context
	@path = path if @paths.empty?

	# add parent directory to paths array
	wd = File.dirname(path)
	@paths << wd unless @paths.include?(wd)

	load_context(path) if File.file?(path)

	# return the newly imported context
	return self
      end

      def inherit(path)
	find_path(path) do |file|
	  new_context = Context.create(file)
	  @contexts << new_context
	  return new_context
	end

	raise ContextNotFound, "context '#{path}' not found", caller
      end

      def dist(&block)
	# distribute block over self
	result = [instance_eval(&block)]

	# distribute block over context dependencies
	return result + @contexts.map { |sub_context| sub_context.dist(&block) }
      end

      def action(name,&block)
	@actions[name.to_sym] = block
      end

      def actions
	@actions.keys
      end

      def has_action?(name)
	name = name.to_sym

	return true if @actions.has_key?(name)

	@contexts.each do |sub_context|
	  return true if sub_context.has_action?(name)
	end
	return false
      end

      def get_action(name)
	name = name.to_sym

	return @actions[name] if @actions.has_key?(name)

	@contexts.each do |sub_context|
	  if (action = sub_context.get_action(name))
	    return action
	  end
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

      def Object.context(id)
	contextify(id)

	# define kernel-level context method
	Kernel.module_eval <<-end_eval
	  def ronin_#{id}(name='#{id}',&block)
	    if ronin_context_pending?
	      ronin_contexts[:#{id}] = block
	      return nil
	    else
	      return #{self}.new(name,&block)
	    end
	  end
	end_eval

	Ronin.module_eval <<-end_eval
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

      def Object.attr_action(*ids)
	for id in ids
	  class_eval <<-"end_eval"
	    def action_#{id}(&block)
	      action(:#{id},&block)
	    end
	  end_eval
	end
      end

      # Name of context to load
      context :context

      # Setup action
      attr_action :setup
      
      # Teardown action
      attr_action :teardown

      def method_missing(sym,*args)
	name = sym.id2name

	# perform action
	return perform_action(sym,*args) if has_action?(name)

	raise NoMethodError.new(name)
      end

    end
  end
end
