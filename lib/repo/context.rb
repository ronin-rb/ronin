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
require 'repo/exceptions/actionnotfound'
require 'repo/exceptions/contextnotfound'
require 'repo/exceptions/objectnotfound'

module Ronin
  module Repo
    class Context < Module

      # Dependencies of the Context
      attr_reader :deps

      # Path to the Context
      attr_reader :paths

      def initialize
	@deps = []
	@scope = []
	@paths = []
	@actions = Hash.new { Hash.new }
      end

      def perform_setup
	context_perform_action(top_scope,'setup')
      end

      def perform_teardown
	context_perform_action(top_scope,'teardown')
      end

      def perform_action(name,*args)
	unless @actions.has_key?(name)
	  raise ActionNotFound, "cannot find action '#{name}' in group '#{self}'", caller
	end

	return @actions[name][current_scope].call(*args)
      end

      def context_perform_action(context,name,*args)
	unless @actions.has_key?(name)
	  raise ActionNotFound, "cannot find action '#{name}' in group '#{self}'", caller
	end

	unless @actions[name].has_key?(context)
	  raise ActionNotFound, "cannot find action '#{context}::#{name}' in context '#{self}'", caller
	end

	return @actions[name][context].call(*args)
      end

      def has_action?(name)
	@actions.has_key?(name)
      end

      def context_has_action?(context,name)
	return false unless @actions.has_key?(name)
	return false unless @actions[name].has_key?(context)
	return true
      end

      protected

      def Context.attr_action(*ids)
	for id in ids
	  module_eval <<-"end_eval"
	    def #{id}(&block)
	      @actions[#{id}][current_scope] = block
	    end
	  end_eval
	end
      end

      # Setup action
      attr_action :setup
      
      # Teardown action
      attr_action :teardown

      def action(id,&block)
	@actions[id][current_scope] = block
      end

      def ronin_path(path,&block)
	@paths.each do |wd|
	  real_path = File.join(wd,path)
	  block.call(real_path) if File.exists?(real_path)
	end
      end

      def ronin_glob(pattern,&block)
	@paths.each do |wd|
	  Dir.glob(File.join(wd,pattern)).each do |path|
	    block.call(path)
	  end
	end
      end

      def ronin_file(path,&block)
	ronin_path(path) do |file|
	  block.call(file) if File.file?(file)
	end
      end

      def ronin_dir(path,&block)
	ronin_path(path) do |dir|
	  block.call(dir) if File.directory?(dir)
	end
      end

      def ronin_load(path)
	ronin_path(path) do |file|
	  return load(file)
	end
      end

      def ronin_require(path)
	ronin_path(path) do |file|
	  return require(file)
	end
      end

      def contains?(path)
	ronin_path(path) do |file|
	  return true
	end
	return false
      end

      def contains_file?(path)
	ronin_path(path) do |file|
	  return true if File.file?(file)
	end
	return false
      end

      def contains_directory?(path)
	ronin_path(path) do |file|
	  return true if File.directory?(file)
	end
	return false
      end

      def depend_context(name,path=nil)
	if path
	  context_path = File.join(path,name,'.rb')
	  unless File.file?(context_path)
	    raise ContextNotFound, "context file '#{context_path}' does not exist", caller
	  end

	  @paths << path unless @paths.include?(path)
	end

	return load_context(name)
      end

      def load_context(name)
	return false if @deps.include?(name)

	ronin_file(name + '.rb') do |file|
	  return false unless require(file)

	  @deps << name
	  enter_scope(name)
	  class_eval(get_context) if has_context?
	  leave_scope
	  return true
	end

	raise ContextNotFound, "context '#{name}' not found", caller
      end

      def load_object(path)
	ronin_file(path) do |file|
	  obj = ObjectContext.new(self)
	  obj.load(file)
	  return obj
	end

	raise ObjectNotFound, "object file '#{path}' not found", caller
      end

      def method_missing(sym,*args)
	perform_action(sym,*args)
      end

      private

      def enter_scope(name)
	@scope.unshift(name)
      end

      def current_scope
	@scope[0]
      end

      def top_scope
	@scope.last
      end

      def leave_scope
	@scope.shift
      end

    end
  end
end
