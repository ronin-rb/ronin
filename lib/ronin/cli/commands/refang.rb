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

require_relative '../value_processor_command'

require 'ronin/support/network/defang'

module Ronin
  class CLI
    module Commands
      #
      # Re-fangs a defanged URL, hostname, or IP address.
      #
      # ## Usage
      #
      #     ronin refang [options] [{URL | HOST | IP} ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [URL | HOST | IP ...]            A defanged URL, hostname, or IP address
      #
      # ## Examples
      #
      #     ronin refang hxxps://www[.]evil[.]com/foo/bar/baz
      #     ronin refang www[.]example[.]com
      #     ronin refang 192[.]168[.]1[.]1
      #     ronin refang --file urls.txt
      #
      # @since 2.2.0
      #
      class Refang < ValueProcessorCommand

        usage '[options] [{URL | HOST | IP} ...]'

        argument :value, required: false,
                         repeats:  true,
                         usage:    'URL | HOST | IP',
                         desc:     'A defanged URL, hostname, or IP address'

        examples [
          'hxxps://www[.]evil[.]com/foo/bar/baz',
          'www[.]example[.]com',
          '192[.]168[.]1[.]1',
          '--file urls.txt'
        ]

        description 'Refangs a defanged URLs, hostnames, or IP addresses'

        man_page 'ronin-refang.1'

        #
        # Refangs a defanged URL, hostname, or IP address.
        #
        # @param [String] value
        #   The value to refang.
        #
        def process_value(value)
          puts Support::Network::Defang.refang(value)
        end

      end
    end
  end
end
