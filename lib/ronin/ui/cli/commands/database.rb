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

require 'ronin/ui/cli/command'
require 'ronin/database'

require 'addressable/uri'

module Ronin
  module UI
    module CLI
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
              Ronin::Database.repositories.each do |name,uri|
                print_hash uri, :title => name
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
            if options[:uri]
              Addressable::URI.parse(options[:uri]).to_hash
            else
              {
                :adapter => options[:adapter],
                :host => options[:host],
                :port => options[:port],
                :user => options[:user],
                :password => options[:password],
                :database => (options[:database] || options[:path])
              }
            end
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
              Ronin::Database.repositories[name] = repository_uri
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
