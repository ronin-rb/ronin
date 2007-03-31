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

      # Name of context
      attr_reader :name

      # Working directory of the context
      attr_reader :wd

      # Scopes of the context
      attr_reader :scopes

      def initialize(path)
	unless File.file?(path)
	  raise ContextNotFound, "context '#{name}' does not exist", caller
	end

	@name = scope_name(path)
	@wd = File.dirname(path)
	@actions = {}
	@deps = []

	load(file)
	module_eval(get_context) if has_context?
      end

      def perform_setup
	perform_action(:setup)
      end

      def perform_teardown
	perform_action(:teardown)
      end

      def has_action?(name)
	return true if @actions.has_key?(name)

	@scopes.each do |sub_scope|
	  return true if sub_scope.has_action?(name)
	end
	return false
      end

      def perform_action(name,*args)
	return @actions[name].call(*args) if @actions.has_key?(name)

	@scopes.each do |sub_scope|
	  return sub_scope.perform_action(name,*args) if sub_scope.has_action?(name)
	end
	raise ActionNotFound, "cannot find action '#{name}' in group '#{self}'", caller
      end

      def has_scope?(name)
	return true if name==@name

	@scopes.each do |scope|
	  return true if scope.has_scope?(name)
	end
	return false
      end

      def scope(name)
	return self if name==@name

	@scopes.each do |sub_scope|
	  return sub_scope.scope(name) if sub_scope.has_scope?(name)
	end
	return nil
      end

      protected

      def Context.attr_action(*ids)
	for id in ids
	  module_eval <<-"end_eval"
	    def #{id}(&block)
	      action(:#{id},&block)
	    end
	  end_eval
	end
      end

      # Setup action
      attr_action :setup
      
      # Teardown action
      attr_action :teardown

      def action(sym,&block)
	@actions[sym] = block
      end

      def ronin_path(path)
	real_path = File.join(@wd,path)

        unless File.exists?(real_path)
	  return nil
	end

	if block_given?
	  yield real_path 
	else
	  return real_path
	end
      end

      def ronin_glob(pattern,&block)
	Dir.glob(File.join(@wd,pattern)).each do |path|
	  block.call(path)
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

      def depend(path)
	ronin_path(path) do |file|
	  @scopes << Context.new(path) unless has_scope?(scope_name(path))
	  return
	end

	raise ContextNotFound, "context '#{name}' does not exist", caller
      end

      def load_object(path)
	ronin_file(path) do |file|
	  obj = ObjectContext.new(self)
	  obj.load(file)
	  return obj
	end

	raise ObjectNotFound, "object file '#{path}' not found", caller
      end

      def scope_name(path)
	File.basename(path).chomp(File.extname(path))
      end

      def method_missing(sym,*args)
	return scope(sym.id2name) if has_scope?(sym.id2name)
	return perform_action(sym,*args) if has_action?(sym)
      end

    end
  end
end
