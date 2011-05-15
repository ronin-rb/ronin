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
require 'ronin/email_address'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-emails` command.
        #
        class Emails < ResourcesCommand

          model EmailAddress

          query_option :with_hosts, :type => :array,
                                    :aliases => '-H',
                                    :banner => 'HOST [...]'

          query_option :with_ips, :type => :array,
                                  :aliases => '-I',
                                  :banner => 'IP [...]'

          query_option :with_users, :type => :array,
                                    :aliases => '-u',
                                    :banner => 'NAME [...]'

          class_option :list, :type => :boolean,
                              :default => true,
                              :aliases => '-l'

          class_option :import, :type => :string,
                                :aliases => '-i',
                                :banner => 'FILE'

          #
          # Queries the {EmailAddress} model.
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
          # Imports email addresses from a file.
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

                email = begin
                          EmailAddress.parse(line)
                        rescue => e
                          print_error e.message
                          next
                        end

                if email.save
                  print_info "Imported #{email}"
                else
                  print_error "Unable to import #{line.dump}."
                end
              end
            end
          end

        end
      end
    end
  end
end
