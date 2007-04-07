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
      attr_reader :scopes

      def initialize(name,path)
	@name = name
	@path = path
	@actions = {}
	@scopes = []

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

	@scopes.each do |scope|
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

      def scope(name)
	# self is the scope
	return self if name==@name

	# search sub-scopes
	@scopes.each do |context|
	  sub_scope = context.scope(name)
	  return sub_scope if sub_scope
	end
	return nil
      end

      def dist(&block)
	# evaluate block within self
	results = [instance_eval(&block)]

	# distribute block within sub-scopes
	@scopes.each do |context|
	  results.concat(context.dist(&block))
	end
	return results
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

	  return false if has_scope?(name)

	  @scopes << Context.new(name,wd)
	  return true
	end

	raise ContextNotFound, "context '#{path}' does not exist", caller
      end

      def method_missing(sym,*args)
	# resolve scopes
	sub_scope = scope(sym.id2name)
	return sub_scope if sub_scope

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
