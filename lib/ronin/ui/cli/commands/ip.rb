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

require 'ronin/ui/cli/model_command'
require 'ronin/extensions/ip_addr'
require 'ronin/ip_address'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-ip` command.
        #
        class IP < ModelCommand

          self.model = IPAddress

          query_option :v4, :type => :boolean, :aliases => '-4' do |ips|
            ips.all(:version => 4)
          end

          query_option :v6, :type => :boolean, :aliases => '-6' do |ips|
            ips.all(:version => 6)
          end

          query_option :ports, :type => :array, :aliases => '-p' do |ips,ports|
            ips.all('ports.number' => ports)
          end

          query_option :macs, :type => :array, :aliases => '-M' do |ips,macs|
            ips.all('mac_addresses.address' => macs)
          end

          query_option :hosts, :type => :array, :aliases => '-H' do |ips,hosts|
            ips.all('host_names.address' => hosts)
          end

          class_option :list, :type => :boolean,
                              :default => true,
                              :aliases => '-l'

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
            elsif options.list?
              super
            end
          end

          protected

          #
          # Extracts and saves IP Addresses from a file.
          #
          # @param [String] path
          #   The path of the file.
          #
          # @since 1.0.0
          #
          def import(path)
            Database.setup

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
