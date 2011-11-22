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
require 'ronin/repository'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-repos` command.
        #
        class Repos < ModelCommand

          desc 'Lists Ronin Repositories'
          argument :name, :type     => :string,
                          :required => false

          #
          # Executes the command.
          #
          def execute
            if name
              repository = begin
                             Repository.find(name)
                           rescue RepositoryNotFound => e
                             print_error e.message
                             exit -1
                           end

              print_repository(repository)
            else
              print_array Repository.all
            end
          end

          protected

          #
          # Prints information about a Repository.
          #
          # @param [Repository] repo
          #   The repository to print.
          #
          def print_repository(repo)
            print_title repo.name

            indent do
              if repo.installed?
                puts "Domain: #{repo.domain}"
              else
                puts "Path: #{repo.path}"
              end

              puts "SCM: #{repo.scm}" if repo.scm

              if repo.verbose?
                putc "\n"

                puts "Title: #{repo.title}" if repo.title
                puts "URI: #{repo.uri}" if repo.uri
                puts "Source URI: #{repo.source}" if repo.source
                puts "Website: #{repo.website}" if repo.website

                executables = repo.executables

                unless executables.empty?
                  puts "Executables: #{executables.join(', ')}"
                end

                putc "\n"

                unless repo.script_paths.empty?
                  print_title 'Cached Files'

                  indent do
                    repo.script_paths.each do |script_path|
                      puts script_path.path
                    end
                  end
                end

                if repo.description
                  print_title "Description"

                  indent { puts "#{repo.description}\n\n" }
                else
                  putc "\n"
                end
              else
                putc "\n"
              end
            end
          end

        end
      end
    end
  end
end
