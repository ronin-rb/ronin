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
    class CategoryContext < Module

      # Associated view
      attr_reader :view

      # Depedencies on other Categories
      attr_reader :deps

      # Actions
      attr_reader :actions

      # Working directory
      attr_accessor :path

      def initialize(view,&block)
	@view = view
	@deps = []
	@actions = {}
	@path = ""

	class_eval(&block)
      end

      def depend(name)
	@deps << @view.load_category(name)
      end

      def path
	return @path
      end

      def ronin_path(postfix)
      end

      def ronin_file(name)
      end

      def ronin_dir(name)
      end

      def ronin_include(name)
      end

      def ronin_require(name)
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

      def perform_action(name)
	return false unless @actions[name]

	instance_eval(@actions[name])
	return true
      end

      def perform_setup
	perform_action(:setup)
      end

      def perform_teardown
	perform_action(:teardown)
      end

    end

    class Category

      # Associated view
      attr_reader :view

      # Repository
      attr_reader :repo

      # Name of the Category
      attr_reader :name

      # Path to the Category
      attr_reader :path

      def initialize(repo,name,context)
	@repo = repo
	@name = name
	@path = @repo.path + File.SEPARATOR + @name

	@context = context
	@context.path = @path if @context
      end

      def action(name)
	return unless @context

	unless @context.perform_action(name)
	  raise, ActionNotFound, "can not find action '#{name}' in category '#{self}'"
	end
      end

      def setup
	@context.perform_setup if @context
      end

      def teardown
	@context.perform_teardown if @context
      end

      def to_s
	return @repo + File.SEPARATOR + @name
      end

    end
  end
end
