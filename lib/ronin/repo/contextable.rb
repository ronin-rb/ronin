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

require 'ronin/repo/extensions/kernel'
require 'ronin/repo/exceptions/contextnotfound'
require 'ronin/extensions/meta'

module Ronin
  module Repo
    module Contextable
      protected

      def Object.contextify(id)
        # define context_name
        module_eval %{
          def self.context_name
            :#{id}
          end

          def context_name
            :#{id}
          end
        }

        # define load_context for the context_name
        class_def(:load_context) do |path|
          block = Contextable.load_contexts(path)[context_name]
          ronin_contexts.clear

          instance_eval(&block) if block
          return self
        end
      end

      def Contextable.load_contexts(path)
        unless File.file?(path)
          raise ContextNotFound, "context '#{path}' doest not exist", caller
        end

        # push on the path to load
        ronin_pending_contexts.unshift(path)

        load(path)

        # pop off the path to load
        ronin_pending_contexts.shift

        # return the loaded contexts
        return ronin_contexts
      end
    end
  end
end
