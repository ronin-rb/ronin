# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../../command'

require 'ronin/web/cli/commands/new/nokogiri'

module Ronin
  class CLI
    module Commands
      class New < Command
        # An alias for `ronin-web new nokogiri`.
        #
        # @since 2.1.0
        Nokogiri = Ronin::Web::CLI::Commands::New::Nokogiri
      end
    end
  end
end
