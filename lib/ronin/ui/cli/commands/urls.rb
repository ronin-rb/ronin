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

          query_option :http, :type => :boolean
          query_option :https, :type => :boolean

          query_option :hosts, :type => :array,
                               :aliases => '-H',
                               :banner => 'HOST [...]'

          query_option :ports, :type => :array,
                               :aliases => '-P',
                               :banner => 'PORT [...]'

          query_option :directory, :type => :string, 
                                   :aliases => '-d',
                                   :banner => 'SUBDIR'

          query_option :query_param, :type => :array,
                                     :aliases => '-q',
                                     :banner => 'NAME'

          query_option :query_value, :type => :array,
                                     :aliases => '-Q',
                                     :banner => 'VALUE'

          class_option :list, :type => :boolean,
                              :default => true,
                              :aliases => '-l'

          class_option :import, :type => :string,
                                :aliases => '-i',
                                :banner => 'FILE'

          #
          # Queries the {Ronin::URL} model.
          #
          # @since 1.0.0
          #
          def execute
            if options[:import]
              import options[:import]
            elsif options.list?
              super
            end
          end

          protected

          #
          # Imports URLs from a file.
          #
          # @param [String] path
          #   The path to the file.
          #
          # @since 1.0.0
          #
          def import(path)
            File.open(path) do |file|
              file.each_line do |line|
                line.strip!
                next if line.empty?

                url = URL.parse(line)

                if url.save
                  print_info "Imported #{url}"
                else
                  print_error "Could not import #{line.dump}."
                end
              end
            end
          end

          #
          # Prints a URL.
          #
          # @param [Ronin::URL] url
          #   The URL to print.
          #
          # @since 1.0.0
          #
          def print_resource(url)
            return super(url) unless options.verbose?

            print_title url

            indent do
              print_hash(
                'Host' => url.host_name,
                'Port' => url.port.number,
                'Path' => url.path,
                'Fragment' => url.fragment,
                'Last Scanned' => url.last_scanned_at
              )

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
