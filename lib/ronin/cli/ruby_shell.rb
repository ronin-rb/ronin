# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/core/cli/ruby_shell'

module Ronin
  class CLI
    #
    # The interactive Ruby shell for {Ronin}.
    #
    class RubyShell < Core::CLI::RubyShell

      #
      # Initializes the `ronin irb` Ruby shell.
      #
      # @param [String] name
      #   The name of the IRB shell.
      #
      # @param [Object] context
      #   Custom context to launch IRB from within.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for
      #   `Ronin::Core::CLI::RubyShell#initialize`.
      #
      def initialize(name: 'ronin', context: Ronin, **kwargs)
        super(name: name, context: context, **kwargs)
      end

    end
  end
end
