#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/version'

module Ronin
  module Installation

    #
    # Finds the additional Ronin libraries, installed on the system as
    # RubyGems.
    #
    # @return [Hash{String => Gem::Specification}]
    #   The names and gem-specs of the additional Ronin libraries.
    #
    # @since 0.4.0
    #
    def Installation.gems
      unless defined?(@@ronin_gems)
        version = Gem::Requirement.new(">=#{Ronin::VERSION}")
        ronin = Gem.source_index.find_name('ronin',version).first

        @@ronin_gems = {}

        if ronin
          ronin.dependent_gems.each do |gems|
            gem = gems.first

            @@ronin_gems[gem.name] = gem
          end
        end
      end

      return @@ronin_gems
    end

    #
    # The names of the additional Ronin libraries installed on the system.
    #
    # @return [Array<String>]
    #   The library names.
    #
    # @since 0.4.0
    #
    def Installation.libraries
      Installation.gems.keys
    end

  end
end
