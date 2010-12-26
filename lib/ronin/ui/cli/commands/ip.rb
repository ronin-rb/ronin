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

          query_option :mac, :type => :array, :aliases => '-M' do |ips,macs|
            ips.all('mac_addresses.address' => macs)
          end

          query_option :hostname, :type => :array, :aliases => '-H' do |ips,names|
            ips.all('host_names.address' => names)
          end

          class_option :list, :type => :boolean,
                              :default => true,
                              :aliases => '-l'

          #
          # Queries the {IPAddress} model.
          #
          # @since 1.0.0
          #
          def execute
            if options.list?
              super
            end
          end

          protected

          #
          # Prints an IP Address.
          #
          # @param [IPAddress] ip
          #   The IP Address to print.
          #
          # @since 1.0.0
          #
          def print_resource(ip)
            if options.verbose?
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
            else
              super(ip)
            end
          end

        end
      end
    end
  end
end
