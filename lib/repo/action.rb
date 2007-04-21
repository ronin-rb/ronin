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

require 'repo/exceptions/actionunbound'

module Ronin
  module Repo
    class Action

      # Name of action
      attr_reader :name

      # Context that the action is bound to
      attr_reader :context

      # Action block
      attr_reader :block

      def initialize(name,context=nil,&block)
	@name = name.to_s
	@context = context
	@block = block
      end

      def bind(context)
	Action.new(@name,@context,&(@block))
      end

      def bind!(context)
	@context = context
      end

      def unbind
	@context = nil
      end

      def call(*args)
	unless @context
	  raise ActionUnbound, "action '#{@name}' is not bound to any context", caller
	end

	call_context(@context,*args)
      end

      def call_context(context,*args)
	context.instance_eval { @block.call(*args) }
      end

      def to_s
	@name
      end

    end
  end
end
