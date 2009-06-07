#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

module Ronin
  module Shell

    # Default shell prompt
    DEFAULT_PROMPT = '>'

    #
    # Creates and starts a new Shell object with the specified _options_.
    # If a _block_ is given, it will be passed every command.
    #
    # _options_ may contain the following keys:
    # <tt>:name</tt>:: Name of the shell.
    # <tt>:prompt</tt>:: Prompt to use for the shell, defaults to
    #                    +DEFAULT_PROMPT+.
    #
    #   Shell.start(:prompt => '$') { |shell,line| system(line) }
    #
    def Shell.start(options={},&block)
      name = (options[:name] || '')
      prompt = (options[:prompt] || DEFAULT_PROMPT)

      history_rollback = 0

      loop do
        line = Readline.readline("#{name}#{prompt} ")

        if line =~ /^\s*exit\s*$/
          break
        else
          Readline::HISTORY << line
          history_rollback += 1

          begin
            block.call(self,line)
          rescue => e
            puts "#{e.class.name}: #{e.message}"
          end
        end
      end

      history_rollback.times { Readline::HISTORY.pop }
      return nil
    end

    #
    # Equivalent to <tt>STDOUT.putc(char)</tt>.
    #
    def Shell.putc(char)
      STDOUT.putc(char)
    end

    #
    # Equivalent to <tt>STDOUT.print(string)</tt>.
    #
    def Shell.print(string)
      STDOUT.print(string)
    end

    #
    # Equivalent to <tt>STDOUT.puts(string)</tt>.
    #
    def Shell.puts(string)
      STDOUT.puts(string)
    end

    alias << puts

    #
    # Equivalent to <tt>STDOUT.printf(string,*objects)</tt>.
    #
    def Shell.printf(string,*objects)
      STDOUT.printf(string,*objects)
    end

  end
end
