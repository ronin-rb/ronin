#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
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
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/ui/cli/resources_command'
require 'ronin/url'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-urls` command.
        #
        class URLs < ResourcesCommand

          model URL

          query_option :http, :type => true
          query_option :https, :type => true

          query_option :hosts, :type  => Array,
                               :flag  => '-H',
                               :usage => 'HOST [...]'

          query_option :ports, :type  => Array[Integer],
                               :flag  => '-P',
                               :usage => 'PORT [...]'

          query_option :directory, :type  => String, 
                                   :flag  => '-d',
                                   :usage => 'SUBDIR'

          query_option :with_query_param, :type  => Array,
                                          :flag  => '-q',
                                          :usage => 'NAME [...]'

          query_option :with_query_value, :type   => Array,
                                          :flag   => '-Q',
                                          :usage  => 'VALUE [...]'

          option :list, :type    => true,
                        :default => true,
                        :flag    => '-l'

          option :import, :type  => String,
                          :flag  => '-i',
                          :usage => 'FILE'

          protected

          #
          # Prints a URL.
          #
          # @param [Ronin::URL] url
          #   The URL to print.
          #
          # @since 1.0.0
          #
          def print_resource(url)
            return super(url) unless @verbose?

            print_title url

            indent do
              print_hash 'Host' => url.host_name,
                         'Port' => url.port.number,
                         'Path' => url.path,
                         'Fragment' => url.fragment,
                         'Last Scanned' => url.last_scanned_at

              unless url.query_params.empty?
                params = {}

                url.query_params.each do |param|
                  params[param.name] = param.value
                end

                print_hash params, :title => 'Query Params'
              end
            end
          end

        end
      end
    end
  end
end
