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
        class Database < Command

          desc "Manages the Ronin Database"
          class_option :add, :type => :string, :banner => 'name', :aliases => '-a'
          class_option :set, :type => :string, :banner => 'name', :aliases => '-s'
          class_option :remove, :type => :string, :banner => 'name', :aliases => '-r'
          class_option :create, :type => :boolean
          class_option :upgrade, :type => :boolean
          
          # repository options
          class_option :uri, :type => :string, :banner => 'sqlite3:///path'
          class_option :adapter, :type => :string, :banner => 'sqlite3'
          class_option :host, :type => :string, :banner => 'www.example.com'
          class_option :port, :type => :numeric, :banner => '9999'
          class_option :user, :type => :string
          class_option :password, :type => :string
          class_option :database, :type => :string, :banner => 'database_name'
          class_option :path, :type => :string, :banner => '/path/file.db'

          def execute
            if (options.create? || options.upgrade?)
              if options.upgrade?
                Ronin::Database.upgrade do
                  print_info "Upgrading the Ronin Database ..."
                end

                print_info "Ronin Database upgrade complete."
              elsif options.create?
                print_info "Creating the Ronin Database ..."

                Ronin::Database.create do
                  print_info "Ronin Database created."
                end
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

          def add_repository
            name = options[:add].to_sym

            Ronin::Database.save do
              Ronin::Database.repositories[name] = repository_uri
            end
          end

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
          end

          def remove_repository
            name = options[:remove].to_sym

            unless Ronin::Database.repository?(name)
              print_error "Unknown Database repository #{name}"
              return
            end

            Ronin::Database.save do
              Ronin::Database.repositories.delete(name)
            end
          end

        end
      end
    end
  end
end
