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
require 'repo/extensions/kernel'
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
      attr_reader :scopes

      def initialize(name,path)
	@name = name
	@path = path
	@actions = {}
	@scopes = []

	file = File.join(@path,@name,'.rb')
	if File.file?(file)
	  load(file)
	  class_eval(get_context) if has_context?
	end
      end

      def has_action?(name)
	return true if @actions.has_key?(name)

	@scopes.each do |scope|
	  return true if scope.has_action?(name)
	end
	return false
      end

      def perform_action(name,*args)
	return @actions[name].call(*args) if @actions.has_key?(name)

	@scopes.each do |scope|
	  return scope.perform_action(name,*args) if scope.has_action?(name)
	end
	raise ActionNotFound, "cannot find action '#{name}' in group '#{self}'", caller
      end

      def perform_setup
	perform_action(:setup)
      end

      def perform_teardown
	perform_action(:teardown)
      end

      def has_scope?(name)
	return true if name==@name

	@scopes.each do |sub_scope|
	  return true if sub_scope.has_scope?(name)
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

      def get_action(sym)
	@action[sym]
      end

      def action(sym,&block)
	@actions[sym] = block
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

	  return false if has_scope?(name)

	  @scope << Context.new(name,wd)
	  return true
	end

	raise ContextNotFound, "context '#{path}' does not exist", caller
      end

      def method_missing(sym,*args)
	return scope(sym.id2name) if has_scope?(sym.id2name)
	return perform_action(sym,*args) if has_action?(sym)
      end

    end
  end
end
