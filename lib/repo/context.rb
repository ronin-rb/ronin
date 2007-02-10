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

require 'exceptions/actionnotfound'

module Ronin
  module Repo
    class Context < Module

      def initialize(&block)
	@deps ||= []
	@actions ||= {}

	class_eval(&block) unless block.nil?
      end

      def depend(repo=nil,name)
	if repo.nil?
	  @deps << $current_config.get_group(name)
	else
	  @deps << $current_config.get_category(repo,name)
	end
      end

      def setup(&block)
	@actions[:setup] = &block
      end

      def action(name,&block)
	@actions[name] = &block
      end

      def teardown(&block)
	@actions[:teardown] = &block
      end

      def ronin_path(path)
      end

      def ronin_file(name)
      end

      def ronin_dir(name)
      end

      def ronin_include(name)
      end

      def ronin_require(name)
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

	raise, ActionNotFound, "cannot find action '#{name}' in group '#{self}'"
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

      def method_missing(name,*args)
	perform_action(name,*args)
      end
    end
  end
end
