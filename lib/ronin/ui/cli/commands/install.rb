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
require 'ronin/repository'
require 'ronin/database'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-install` command.
        #
        class Install < Command

          desc 'Installs Ronin Repositories'
          class_option :rsync, :type => :boolean
          class_option :svn,   :type => :boolean
          class_option :hg,    :type => :boolean
          class_option :git,   :type => :boolean

          argument :uri, :type     => :string,
                         :required => true,
                         :banner   => '[URI|PATH]'

          #
          # Executes the command.
          #
          def execute
            scm = if options.rsync?
                    :rsync
                  elsif options.svn?
                    :sub_version
                  elsif options.hg?
                    :mercurial
                  elsif options.git?
                    :git
                  end

            repository = begin
                           if File.directory?(uri)
                             # add local repositories
                             Repository.add(:path => uri, :scm => scm)
                           else
                             # install remote repositories
                             Repository.install(:uri => uri, :scm => scm)
                           end
                         rescue DuplicateRepository => e
                           print_error e.message
                           exit -1
                         end

            print_info "Repository #{repository} installed."

            # print any caching exceptions/errors
            repository.script_paths.each do |script_path|
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

          protected

          #
          # Sets up the install command.
          #
          def setup
            super

            Database.setup
          end

        end
      end
    end
  end
end
