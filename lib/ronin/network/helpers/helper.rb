#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/output/helpers'

module Ronin
  module Network
    module Helpers
      module Helper
        include UI::Output::Helpers

        protected

        #
        # Tests wether an instance variable has been set.
        #
        # @return [true]
        #   The instance variable has been set.
        #
        # @raise [RuntimeError]
        #   The instance variable was not set.
        #
        # @since 0.3.0
        #
        def require_variable(name)
          if instance_variable_get("@#{name}").nil?
            raise(RuntimeError,"the instance variable @#{name} was not set",caller)
          end

          return true
        end
      end
    end
  end
end
