#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  class Shell

    # Default shell prompt
    DEFAULT_PROMPT = '>'

    # Shell name to use
    attr_accessor :name

    # Shell prompt
    attr_accessor :prompt

    #
    # Creates a new Shell object with the given _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:name</tt>:: The name of the shell.
    # <tt>:prompt</tt>::The prompt to use for the shell.
    #
    def initialize(options={})
      @name = options[:name]
      @prompt = (options[:prompt] || DEFAULT_PROMPT)
    end

    #
    # Creates and starts a new Shell object with the specified _options_.
    # If a _block_ is given, it will be passed every command.
    #
    def self.start(options={},&block)
      self.new(options).start(&block)
    end

    #
    # Starts the shell using the given _block_ to process commands.
    #
    def start(&block)
      history_rollback = 0

      loop do
        line = Readline.readline("#{@name}#{@prompt} ")

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

      history_rollback.times do
        Readline::HISTORY.pop
      end

      return nil
    end

    #
    # Equivalent to <tt>STDOUT.putc(char)</tt>.
    #
    def putc(char)
      STDOUT.putc(char)
    end

    #
    # Equivalent to <tt>STDOUT.print(string)</tt>.
    #
    def print(string)
      STDOUT.print(string)
    end

    #
    # Equivalent to <tt>STDOUT.puts(string)</tt>.
    #
    def puts(string)
      STDOUT.puts(string)
    end

    alias << puts

    #
    # Equivalent to <tt>STDOUT.printf(string,*objects)</tt>.
    #
    def printf(string,*objects)
      STDOUT.printf(string,*objects)
    end

  end
end
