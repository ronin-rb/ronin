#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
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
      # Creates new project directory.
      #
      # ## Usage
      #
      #     ronin new project [options] DIR
      #
      # ## Options
      #
      #         --git                        Initializes a git repo
      #         --rakefile                   Creates a Rakefile
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

          option :rakefile, desc: 'Creates a Rakefile'

          argument :path, required: true,
                          desc:     'The directory to create'

          man_page 'ronin-new-project.1'

          #
          # Runs the `ronin new project` command.
          #
          # @param [String] path
          #   The path to the new project directory to create.
          #
          def run(path)
            @project_name = File.basename(path)

            mkdir path
            mkdir File.join(path,'lib')

            erb 'Gemfile.erb', File.join(path,'Gemfile')
            cp 'Rakefile', path if options[:rakefile]

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
