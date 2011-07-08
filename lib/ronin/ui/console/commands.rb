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

require 'env'
require 'tempfile'

module Ronin
  module UI
    module Console
      #
      # Allows for executing shell commands prefixed by a `!`.
      #
      # @since 1.2.0
      #
      module Commands
        # Names and statuses of executables.
        EXECUTABLES = Hash.new do |hash,key|
          hash[key] = Env.paths.any? do |dir|
            path = dir.join(key)

            (path.file? && path.executable?)
          end
        end

        # Blacklist of known commands that conflict with Ruby keywords.
        BLACKLIST = Set[
          '[', 'ap', 'begin', 'case', 'class', 'def', 'fail', 'false',
          'for', 'if', 'lambda', 'load', 'loop', 'module', 'p', 'pp',
          'print', 'proc', 'puts', 'raise', 'require', 'true', 'undef',
          'unless', 'until', 'warn', 'while'
        ]

        #
        # Dynamically execute shell commands, instead of Ruby.
        #
        # @param [String] input
        #   The input from the console.
        #
        # @api private
        #
        def loop_eval(input)
          if input[0,1] == '!'
            command = input[1..-1]
            name, arguments = command.split(' ',2)

            unless BLACKLIST.include?(name)
              if Commands.singleton_class.method_defined?(name)
                return Commands.send(name,arguments)
              elsif executable?(name)
                return system(command)
              end
            end
          end

          super(input)
        end

        #
        # Equivalent of the `cd` command, using `Dir.chdir`.
        #
        # @param [String] arguments
        #   The arguments of the command.
        #
        # @return [Boolean]
        #   Specifies whether the directory change was successful.
        #
        # @api semipublic
        #
        def Commands.cd(arguments)
          old_pwd = Dir.pwd

          new_cwd = if arguments.empty?
                      Env.home
                    elsif arguments == '-'
                      unless ENV['OLDPWD']
                        print_warning 'cd: OLDPWD not set'
                        return false
                      end

                      ENV['OLDPWD']
                    else
                      arguments
                    end

          Dir.chdir(new_cwd)
          ENV['OLDPWD'] = old_pwd
          return true
        end

        #
        # Equivalent of the `export` or `set` commands.
        #
        # @param [String] arguments
        #   The arguments of the command.
        #
        # @return [true]
        #
        # @api semipublic
        #
        def Commands.export(arguments)
          arguments.split(' ').each do |pair|
            name, value = pair.split('=',2)

            ENV[name] = value
          end
        end

        #
        # Edits a path and re-loads the code.
        #
        # @param [String] path 
        #   The path of the file to re-load.
        #
        # @return [Boolean]
        #   Specifies whether the code was successfully re-loaded.
        #
        # @api private
        #
        def Commands.edit(path=nil)
          if Env.editor
            path ||= Tempfile.new(['ronin-console', '.rb']).path

            system(Env.editor,path) && load(path)
          else
            print_error "Please set the EDITOR env variable"
            return false
          end
        end

        protected

        #
        # Determines if an executable exists on the system.
        #
        # @param [String] name
        #   The program name or path.
        #
        # @return [Boolean]
        #   Specifies whether the executable exists.
        #
        # @api private
        #
        def executable?(name)
          (File.file?(name) && File.executable?(name)) || EXECUTABLES[name]
        end
      end
    end
  end
end

Ripl::Shell.send :include, Ronin::UI::Console::Commands
