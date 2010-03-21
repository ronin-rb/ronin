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

require 'ronin/ui/command_line/command'
require 'ronin/database'

module Ronin
  module UI
    module CommandLine
      module Commands
        #
        # The `ronin database` command.
        #
        class Database < Command

          desc "Manages the Ronin Database"
          class_option :add, :type => :string, :banner => 'NAME', :aliases => '-a'
          class_option :set, :type => :string, :banner => 'NAME', :aliases => '-s'
          class_option :remove, :type => :string, :banner => 'NAME', :aliases => '-r'
          class_option :clear, :type => :string, :banner => 'NAME', :aliases => '-C'
          
          # repository options
          class_option :uri, :type => :string, :banner => 'sqlite3:///path'
          class_option :adapter, :type => :string, :banner => 'sqlite3'
          class_option :host, :type => :string, :banner => 'www.example.com'
          class_option :port, :type => :numeric, :banner => '9999'
          class_option :user, :type => :string
          class_option :password, :type => :string
          class_option :database, :type => :string, :banner => 'NAME'
          class_option :path, :type => :string, :banner => '/path/file.db'

          #
          # Displays or modifies the Ronin Database configuration.
          #
          def execute
            if options[:clear]
              name = options[:clear].to_sym

              print_info "Clearing the Database repository #{name} ..."

              Ronin::Database.clear(name) do
                print_info "Database repository #{name} cleared."
              end

              return
            end

            if options[:add]
              add_repository
            elsif options[:set]
              set_repository
            elsif options[:delete]
              delete_repository
            else
              indent do
                Ronin::Database.repositories.each do |name,uri|
                  puts "#{name}: #{uri}"
                end
              end
            end
          end

          protected

          #
          # Creates a repository URI from the command options.
          #
          # @return [Addressable::URI]
          #   The repository URI.
          #
          def repository_uri
            uri = if options[:uri]
                    Addressable::URI.parse(options[:uri])
                  else
                    Addressable::URI.new()
                  end

            uri.scheme = options[:adapter] if options[:adapter]
            uri.host = options[:host] if options[:host]
            uri.port = options[:port] if options[:port]
            uri.user = options[:user] if options[:user]
            uri.password = options[:password] if options[:password]

            if options[:database]
              uri.path = options[:database]
            elsif options[:path]
              uri.path = options[:path]
            end

            return uri
          end

          #
          # Adds a new Database repository.
          #
          def add_repository
            name = options[:add].to_sym

            Ronin::Database.save do
              Ronin::Database.repositories[name] = repository_uri
            end

            print_info "Database repository #{name} added."
          end

          #
          # Sets the URI for an existing Database repository.
          #
          def set_repository
            name = options[:set].to_sym

            unless Ronin::Database.repository?(name)
              print_error "Unknown Database repository #{name}"
              return
            end

            Ronin::Database.save do
              if options[:uri]
                Ronin::Database.repositories[name] = repository_uri
              else
                uri = Ronin::Database.repositories[name]

                uri.scheme = options[:adapter] if options[:adapter]
                uri.host = options[:host] if options[:host]
                uri.port = options[:port] if options[:port]
                uri.user = options[:user] if options[:user]
                uri.password = options[:password] if options[:password]

                if options[:database]
                  uri.path = options[:database]
                elsif options[:path]
                  uri.path = options[:path]
                end
              end
            end

            print_info "Database repository #{name} updated."
          end

          #
          # Removes an existing Database repository.
          #
          def remove_repository
            name = options[:remove].to_sym

            unless Ronin::Database.repository?(name)
              print_error "Unknown Database repository #{name}"
              return
            end

            Ronin::Database.save do
              Ronin::Database.repositories.delete(name)
            end

            print_info "Database repository #{name} removed."
          end

        end
      end
    end
  end
end
