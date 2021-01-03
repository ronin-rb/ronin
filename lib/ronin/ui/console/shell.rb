#
# Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/config'

require 'set'
require 'shellwords'

module Ronin
  module UI
    module Console
      #
      # Allows for executing shell commands prefixed by a `!`.
      #
      # @since 1.5.0
      #
      # @api private
      #
      module Shell
        # Names and statuses of executables.
        EXECUTABLES = Hash.new do |hash,key|
          hash[key] = Config::BIN_DIRS.any? do |dir|
            path = File.join(dir,key)

            (File.file?(path) && File.executable?(path))
          end
        end

        # Regexp to recognize `!commands`.
        PATTERN = /^![a-zA-Z][a-zA-Z0-9\._-]*/

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
          if (@buffer.nil? && input =~ PATTERN)
            command = input[1..-1]
            name, arguments = parse_command(command)

            unless BLACKLIST.include?(name)
              if Shell.singleton_class.method_defined?(name)
                arguments ||= []

                return Shell.send(name,*arguments)
              elsif executable?(name)
                return Shell.exec(name,*arguments)
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
        def self.exec(*arguments)
          system(Shellwords.shelljoin(arguments))
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
        def self.cd(*arguments)
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
        def self.export(*arguments)
          arguments.each do |pair|
            name, value = pair.split('=',2)

            ENV[name] = value
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
          # evaluate embedded Ruby expressions
          command = command.gsub(/\#\{[^\}]*\}/) do |expression|
            eval(expression[2..-2],Ripl.config[:binding]).to_s.dump
          end

          arguments = Shellwords.shellsplit(command)
          name      = arguments.shift

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

Ripl::Shell.send :include, Ronin::UI::Console::Shell
