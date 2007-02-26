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

module Ronin
  module Repo
    class Context < Module

      include FileAccess

      # Path to the Category
      attr_reader :path      

      def initialize(path)
	@path = path
	@deps = []
	@actions = {}
      end

      def perform_setup
	@deps.each do |dep|
	  dep.perform_setup
	end
	@actions[:setup].call if @actions.has_key?(:setup)
      end

      def perform_action(name,*args)
	if @actions.has_key?(name)
	  return @actions[name].call(*args)
	end

	@deps.each do |dep|
	  if dep.has_action?(name)
	    return dep.perform_action(name,*args)
	  end
	end

	raise ActionNotFound, "cannot find action '#{name}' in group '#{self}'", caller
      end

      def perform_teardown
	@actions[:teardown].call if @actions.has_key?(:teardown)
	@deps.each do |dep|
	  dep.perform_teardown
	end
      end

      def has_action?(name)
	return true if @actions.has_key(name)
	@deps.each do |dep|
	  return true if dep.has_action?(name)
	end
      end

      protected

      def Context.attr_action(*ids)
	for id in ids
	  module_eval <<-"end_eval"
	    def #{id}(&block)
	      @actions[#{id}] = block
	    end
	  end_eval
	end
      end

      # Setup action
      attr_action :setup
      
      # Teardown action
      attr_action :teardown

      def require_context(path)
	unless File.file?(path)
	  raise ContextNotFound, "context file '#{path}' does not exist", caller
	end

 	load(path)

	unless has_context?
	  raise ContextNotFound, "context file '#{path}' does not contain a context definition", caller
	end
	class_eval(get_context)
      end

      def load_context(path)
	return unless File.file?(path)

	load(path)
	class_eval(get_context) if has_context?
      end

      # TODO: split 'name' into [repo, category]
      def depend(name)
	if repo.nil?
	  @deps << config.get_group(name)
	else
	  @deps << config.get_category(repo,name)
	end
      end

      def action(name,&block)
	@actions[name] = block
      end

      def ronin_file(name)
	contains_file?(name)
      end

      def ronin_dir(name)
	contains_dir?(name)
      end

      def ronin_load(name)
	load_file(name)
      end

      def ronin_require(name)
	require_file(name)
      end

      def method_missing(name,*args)
	perform_action(name,*args)
      end

    end
  end
end
