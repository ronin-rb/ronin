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

require 'ronin/ui/cli/model_command'
require 'ronin/extensions/ip_addr'
require 'ronin/ip_address'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-ips` command.
        #
        class IPs < ModelCommand

          self.model = IPAddress

          query_option :v4, :type => :boolean, :aliases => '-4'
          query_option :v6, :type => :boolean, :aliases => '-6'

          query_option :with_ports, :type => :array,
                                    :aliases => '-p',
                                    :banner => 'PORT [...]'

          query_option :with_macs, :type => :array,
                                   :aliases => '-M',
                                   :banner => 'MAC [...]'

          query_option :with_hosts, :type => :array,
                                    :aliases => '-H',
                                    :banner => 'HOST [...]'

          class_option :list, :type => :boolean,
                              :default => true,
                              :aliases => '-l'

          class_option :lookup, :type => :string,
                                :aliases => '-L',
                                :banner => 'HOST'

          class_option :import, :type => :string,
                                :aliases => '-i',
                                :banner => 'FILE'

          #
          # Queries the {IPAddress} model.
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
          # Looks up a host name.
          #
          # @param [String] host
          #   The host name to lookup.
          #
          # @since 1.0.0
          #
          def lookup(host)
            print_info "Looking up #{host} ..."

            IPAddress.lookup(host).each do |ip|
              print_info "  #{ip}"
            end

            print_info "Looked up #{host}"
          end

          #
          # Extracts and saves IP Addresses from a file.
          #
          # @param [String] path
          #   The path of the file.
          #
          # @since 1.0.0
          #
          def import(path)
            File.open(options[:import]) do |file|
              file.each_line do |line|
                IPAddr.extract(line) do |match|
                  ip = IPAddress.new(:address => match)

                  if ip.save
                    print_info "Imported #{ip}"
                  else
                    print_error "Unable to import #{match.dump}."
                  end
                end
              end
            end
          end

          #
          # Prints an IP Address.
          #
          # @param [IPAddress] ip
          #   The IP Address to print.
          #
          # @since 1.0.0
          #
          def print_resource(ip)
            return super(ip) unless options.verbose?

            print_title ip.address

            indent do
              if (org = ip.organization)
                print_hash('Organization' => org)
              end

              if (last_scanned_at = ip.last_scanned_at)
                print_hash('Last Scanned' => last_scanned_at)
              end

              unless ip.mac_addresses.empty?
                print_array ip.mac_addresses, :title => 'MAC Addresses'
              end

              unless ip.host_names.empty?
                print_array ip.host_names, :title => 'Hostnames'
              end

              unless ip.open_ports.empty?
                print_section 'Open Ports' do
                  ip.open_ports.each do |port|
                    if port.service
                      puts "#{port}\t#{port.service}"
                    else
                      puts port
                    end
                  end
                end
              end
            end
          end

        end
      end
    end
  end
end
