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
require 'ronin/host_name'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-hosts` command.
        #
        class Hosts < ModelCommand

          self.model = HostName

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

          class_option :resolv, :type => :string,
                                :aliases => '-r',
                                :banner => 'HOST'

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
            elsif options[:resolv]
              resolv options[:resolv]
            elsif options.list?
              super
            end
          end

          protected

          #
          # Resolves a host name.
          #
          # @param [String] name
          #   The host name to resolv.
          #
          # @since 1.0.0
          #
          def resolv(name)
            Database.setup

            print_info "Resolving #{name} ..."

            host = HostName.first_or_new(:address => name)
            host.resolv_all { |ip| print_info "  #{ip}" }

            print_info "Resolved #{name}"
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
            Database.setup

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
