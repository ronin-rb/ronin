# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/cli/command'
require 'ronin/core/cli/generator'
require 'ronin/root'

module Ronin
  class CLI
    module Commands
      #
      # Creates new Ruby project directory.
      #
      # ## Usage
      #
      #     ronin new project [options] DIR
      #
      # ## Options
      #
      #         --git                        Initializes a git repo
      #         --ruby-version VERSION       The desired ruby version for the project
      #         --rakefile                   Creates a Rakefile
      #     -D, --dockerfile                 Adds a Dockerfile to the new project
      #     -h, --help                       Print help information
      #
      # ## Arguments
      # 
      #     PATH                             The directory to create
      #
      class New < Command
        class Project < Command

          include Core::CLI::Generator

          template_dir File.join(ROOT,'data','new','project')

          usage '[options] DIR'

          option :git, desc: 'Initializes a git repo'

          option :ruby_version, value: {
                                  type:    String,
                                  usage:   'VERSION',
                                  default: RUBY_VERSION
                                },
                                desc: 'The desired ruby version for the project'

          option :rakefile, desc: 'Creates a Rakefile'

          option :dockerfile, short: '-D',
                              desc: 'Adds a Dockerfile to the new project'

          argument :path, required: true,
                          desc:     'The directory to create'

          description 'Creates a new Ruby project directory'

          man_page 'ronin-new-project.1'

          #
          # Runs the `ronin new project` command.
          #
          # @param [String] path
          #   The path to the new project directory to create.
          #
          def run(path)
            @project_name = File.basename(path)
            @ruby_version = options[:ruby_version]

            mkdir path
            mkdir File.join(path,'lib')

            erb '.ruby-version.erb', File.join(path,'.ruby-version')
            erb 'Gemfile.erb', File.join(path,'Gemfile')

            if options[:rakefile]
              cp 'Rakefile', path
            end

            if options[:dockerfile]
              erb 'Dockerfile.erb', File.join(path,'Dockerfile')
            end

            project_file = File.join(path,"#{@project_name}.rb")

            erb 'project.rb.erb', project_file
            chmod '+x',           project_file

            if options[:git]
              cp '.gitignore', path

              Dir.chdir(path) do
                sh 'git', 'init', '-q', '-b', 'main'
                sh 'git', 'add', '.'
                sh 'git', 'commit', '-q', '-m', 'Initial commit.'
              end
            end
          end

        end
      end
    end
  end
end
