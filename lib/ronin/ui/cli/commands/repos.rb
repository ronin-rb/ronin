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

          desc 'Manages Ronin repositories'
          class_option :add, :type => :string,
                             :aliases => '-A',
                             :banner => 'PATH'
          class_option :install, :type => :string,
                                 :aliases => '-I',
                                 :banner => 'URI'
          class_option :list, :type => :boolean,
                              :aliases => '-l'
          class_option :update, :type => :boolean,
                                :aliases => '-u'
          class_option :uninstall, :type => :string,
                                   :aliases => '-U',
                                   :banner => 'REPO'
          class_option :scm, :type => :string, :aliases => '-S'

          class_option :rsync, :type => :boolean
          class_option :svn, :type => :boolean
          class_option :hg, :type => :boolean
          class_option :git, :type => :boolean

          argument :name, :type => :string, :required => false

          #
          # Executes the command.
          #
          def execute
            if options[:add]
              add options[:add]
            elsif options[:install]
              install options[:install]
            elsif options.update?
              update
            elsif options[:uninstall]
              uninstall options[:uninstall]
            else
              list
            end
          end

          protected

          #
          # The selected SCM.
          #
          # @return [Symbol]
          #   The name of the selected SCM.
          #
          def scm
            @scm ||= if options[:scm]
                       options[:scm].to_sym
                     elsif options.rsync?
                       :rsync
                     elsif options.svn?
                       :sub_version
                     elsif options.hg?
                       :mercurial
                     elsif options.git?
                       :git
                     end
          end

          #
          # Print out any exceptions or validation errors encountered
          # when caching the files of the repository.
          #
          # @param [Repository] repo
          #   The repository that was updated.
          #
          def print_cache_errors(repo)
            repo.script_paths.each do |script_path|
              if script_path.cache_exception
                print_exception script_path.cache_exception
              end

              if script_path.cache_errors
                script_path.cache_errors.each do |error|
                  print_error error
                end
              end
            end
          end

          #
          # Lists installed or added Repositories.
          #
          def list
            unless name
              print_array Repository.all
            else
              repo = begin
                       [Repository.find(name)]
                     rescue RepositoryNotFound => e
                       print_error e.message
                       exit -1
                     end

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

          #
          # Adds a Repository.
          #
          # @param [String] path
          #   The path of the local repository.
          #
          def add(path)
            repo = begin
                     Repository.add!(:path => path, :scm => @scm)
                   rescue DuplicateRepository => e
                     print_error e.message
                     exit -1
                   end

            print_info "Repository #{repo} added."
          end

          #
          # Installs a Repository.
          #
          # @param [String, URI] uri
          #   The URI of the remote repository.
          #
          def install(uri)
            repo = begin
                     Repository.install!(:uri => uri, :scm => scm)
                   rescue DuplicateRepository => e
                     print_error e.message
                     exit -1
                   end

            print_cache_errors(repo)
            print_info "Repository #{repo} has been installed."
          end

          #
          # Updates installed Repositories.
          #
          def update
            repos = if name
                      begin
                        [Repository.find(name)]
                      rescue RepositoryNotFound => e
                        print_error e.message
                        exit -1
                      end
                    else
                      Repository.all
                    end

            repos.each do |repo|
              print_info "Updating repository #{repo} ..."

              repo.update!

              print_cache_errors(repo)
              print_info "Repository updated."
            end
          end

          #
          # Uninstalls a Repository.
          #
          # @param [String] name
          #   The name of the repository.
          #
          def uninstall(name)
            repo = Repository.uninstall!(name)

            print_info "Uninstalling repository #{repo} ..."
          end

        end
      end
    end
  end
end
