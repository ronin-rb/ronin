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
require 'ronin/repository'
require 'ronin/database'

module Ronin
  module UI
    module CommandLine
      module Commands
        #
        # The `ronin repo` command.
        #
        class Repo < Command

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

          def execute
            Database.setup

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
            repo.cached_files.each do |cached_file|
              if cached_file.cache_exception
                print_exception cached_file.cache_exception
              end

              if cached_file.cache_errors
                cached_file.cache_errors.each do |error|
                  print_error error
                end
              end
            end
          end

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

                  if repo.title
                    puts "Title: #{repo.title}"
                  end

                  puts "URI: #{repo.uri}" if repo.uri

                  if repo.source
                    puts "Source URI: #{repo.source}"
                  end

                  if repo.website
                    puts "Website: #{repo.website}"
                  end

                  executables = repo.executables

                  unless executables.empty?
                    puts "Executables: #{executables.join(', ')}"
                  end

                  putc "\n"

                  unless repo.cached_files.empty?
                    print_title 'Cached Files'

                    indent do
                      repo.cached_files.each do |cached_file|
                        puts cached_file.path
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

          def add(path)
            repo = begin
                     Repository.add!(:path => path, :scm => @scm)
                   rescue DuplicateRepository => e
                     print_error e.message
                     exit -1
                   end

            print_info "Repository #{repo} added."
          end

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

          def uninstall(name)
            repo = Repository.uninstall!(name)

            print_info "Uninstalling repository #{repo} ..."
          end

        end
      end
    end
  end
end
