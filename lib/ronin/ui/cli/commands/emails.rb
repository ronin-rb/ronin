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
require 'ronin/email_address'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-emails` command.
        #
        class Emails < ModelCommand

          self.model = EmailAddress

          query_option :hosts, :type => :array, :aliases => '-H' do |emails,hosts|
            emails.all('host_name.address' => hosts)
          end

          query_option :ip, :type => :array, :aliases => '-I' do |emails,ips|
            hosts.all('host_name.ip_addresses.address' => ips)
          end

          query_option :ports, :type => :array, :aliases => '-p' do |emails,ports|
            emails.all('host_name.ports.number' => ports)
          end

          query_option :users, :type => :array, :aliases => '-u' do |emails,users|
            emails.all('user_name.name' => users)
          end

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
                line = line.strip
                email = EmailAddress.parse(line)

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
