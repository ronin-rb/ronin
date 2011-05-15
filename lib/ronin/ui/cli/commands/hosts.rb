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
require 'ronin/host_name'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-hosts` command.
        #
        class Hosts < ResourcesCommand

          model HostName

          query_option :with_ips, :type => :array,
                                  :aliases => '-I',
                                  :banner => 'IP [...]'

          query_option :with_ports, :type => :array,
                                    :aliases => '-p',
                                    :banner => 'PORT [...]'

          query_option :domain, :type => :string,
                                :aliases => '-D',
                                :banner => 'DOMAIN'

          query_option :tld, :type => :string,
                             :aliases => '-T',
                             :banner => 'TLD'

          class_option :list, :type => :boolean,
                              :default => true,
                              :aliases => '-l'

          class_option :lookup, :type => :string,
                                :aliases => '-L',
                                :banner => 'IP'

          class_option :import, :type => :string,
                                :aliases => '-i',
                                :banner => 'FILE'

          #
          # Queries the {HostName} model.
          #
          # @since 1.0.0
          #
          def execute
            if options[:import]
              import options[:import]
            elsif options[:lookup]
              lookup options[:lookup]
            elsif options.list?
              super
            end
          end

          protected

          #
          # Looks up an IP address.
          #
          # @param [String] ip
          #   The IP address to look up.
          #
          # @since 1.0.0
          #
          def lookup(ip)
            print_info "Looking up #{ip} ..."

            HostName.lookup(ip).each do |host|
              print_info "  #{host}"
            end

            print_info "Looked up #{ip}"
          end

          #
          # Imports host names from a file.
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

                host = HostName.new(:address => line)

                if host.save
                  print_info "Imported #{host}"
                else
                  print_error "Unable to import #{line.dump}."
                end
              end
            end
          end

          #
          # Prints a host name.
          #
          # @param [HostName] host
          #   The host name to print.
          #
          # @since 1.0.0
          #
          def print_resource(host)
            return super(host) unless options.verbose?

            print_title host.address

            indent do
              if (org = host.organization)
                print_hash('Organization' => org)
              end

              if (last_scanned_at = host.last_scanned_at)
                print_hash('Last Scanned' => last_scanned_at)
              end

              unless host.ip_addresses.empty?
                print_array host.ip_addresses, :title => 'IP Addresses'
              end

              unless host.open_ports.empty?
                print_section 'Open Ports' do
                  host.open_ports.each do |port|
                    if port.service
                      puts "#{port}\t#{port.service}"
                    else
                      puts port
                    end
                  end
                end
              end

              unless host.email_addresses.empty?
                print_array host.email_addresses, :title => 'Email Addresses'
              end

              unless host.urls.empty?
                print_array host.urls, :title => 'URLs'
              end
            end
          end

        end
      end
    end
  end
end
