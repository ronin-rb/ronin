#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/config'

require 'set'
require 'tempfile'

module Ronin
  module UI
    module Console
      #
      # Allows for executing shell commands prefixed by a `!`.
      #
      # @since 1.2.0
      #
      # @api private
      #
      module Commands
        # Names and statuses of executables.
        EXECUTABLES = Hash.new do |hash,key|
          hash[key] = Config::BIN_DIRS.any? do |dir|
            path = File.join(dir,key)

            (File.file?(path) && File.executable?(path))
          end
        end

        # Prefixes that denote a command, instead of Ruby code.
        PREFIXES = Set['!', '.']

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
        def loop_eval(input)
          if PREFIXES.include?(input[0,1])
            command = input[1..-1]
            name, arguments = parse_command(command)

            unless BLACKLIST.include?(name)
              if Commands.singleton_class.method_defined?(name)
                arguments ||= []

                return Commands.send(name,*arguments)
              elsif executable?(name)
                return Commands.exec(name,*arguments)
              end
            end
          end

          super(input)
        end

        #
        # Default command which executes a command in the shell.
        #
        # @param [Array<String>] arguments
        #   The arguments of the command.
        #
        # @return [Boolean]
        #   Specifies whether the command exited successfully.
        #
        # @since 1.5.0
        #
        def Commands.exec(*arguments)
          system(arguments.join(' '))
        end

        #
        # Equivalent of the `cd` command, using `Dir.chdir`.
        #
        # @param [Array<String>] arguments
        #   The arguments of the command.
        #
        # @return [Boolean]
        #   Specifies whether the directory change was successful.
        #
        def Commands.cd(*arguments)
          old_pwd = Dir.pwd

          new_cwd = if arguments.empty?
                      Config::HOME
                    elsif arguments.first == '-'
                      unless ENV['OLDPWD']
                        print_warning 'cd: OLDPWD not set'
                        return false
                      end

                      ENV['OLDPWD']
                    else
                      arguments.first
                    end

          Dir.chdir(new_cwd)
          ENV['OLDPWD'] = old_pwd
          return true
        end

        #
        # Equivalent of the `export` or `set` commands.
        #
        # @param [Array<String>] arguments
        #   The arguments of the command.
        #
        # @return [true]
        #
        def Commands.export(*arguments)
          arguments.each do |pair|
            name, value = pair.split('=',2)

            ENV[name] = value
          end
        end

        #
        # Edits a path and re-loads the code.
        #
        # @param [Array<String>] path 
        #   The path of the file to re-load.
        #
        # @return [Boolean]
        #   Specifies whether the code was successfully re-loaded.
        #
        def Commands.edit(*arguments)
          path = arguments.first

          if ENV['EDITOR']
            path ||= Tempfile.new(['ronin-console', '.rb']).path

            system(ENV['EDITOR'],path) && load(path)
          else
            print_error "Please set the EDITOR env variable"
            return false
          end
        end

        protected

        #
        # Parses a Console command.
        #
        # @param [String] command
        #   The Console command to parse.
        #
        # @return [String, Array<String>]
        #   The command name and additional arguments.
        #
        # @since 1.5.0
        #
        def parse_command(command)
          name, arguments = command.split(' ',2)
          arguments       = if arguments
                              arguments.split(' ')
                            else
                              []
                            end
                        
          arguments.each do |argument|
            # evaluate embedded Ruby expressions
            argument.gsub!(/\#\{[^\}]*\}/) do |expression|
              eval(expression[2..-2],Ripl.config[:binding]).to_s
            end
          end

          return name, arguments
        end

        #
        # Determines if an executable exists on the system.
        #
        # @param [String] name
        #   The program name or path.
        #
        # @return [Boolean]
        #   Specifies whether the executable exists.
        #
        def executable?(name)
          (File.file?(name) && File.executable?(name)) || EXECUTABLES[name]
        end
      end
    end
  end
end

Ripl::Shell.send :include, Ronin::UI::Console::Commands
