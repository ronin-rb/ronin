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

require 'ronin/ui/command_line/command_line'

require 'optparse'

module Ronin
  module Program
    class Options < OptionParser

      #
      # Creates a new Options object with the specified _program_ name
      # and the given _banner_. If a _block_ is given, it will be passed
      # the newly created Options object.
      #
      def initialize(program,&block)
        @program = program

        super(&block)
      end

      #
      # Creates a new Options object for a Command with the specified
      # _program_ name and command _name_. If a _block_ is given, it
      # will be passed the newly created Options object.
      #
      def Options.command(program,name,&block)
        Options.new("#{program} #{name}",&block)
      end

      #
      # Sets the example usage for the options to the specified _example_.
      #
      def usage=(example)
        self.banner = "Usage: #{@program} #{example}"
        self.separator ''
      end

      #
      # Adds an options section to the help message. If a _block_ is given
      # it will be called before any default options are added.
      #
      def options(&block)
        self.separator '  Options:'

        block.call() if block

        self.on('-h','--help','print this message') { help }
        self.separator ''

        return self
      end

      #
      # Creates an arguments section in the help message using the given
      # _args_.
      #
      def arguments(args={})
        self.separator '  Arguments:'

        args.each do |name,description|
          self.separator "    #{name}\t#{description}"
        end

        self.separator ''
        return self
      end

      #
      # Addes a summary section with the specified _text_.
      #
      def summary(text)
        self.separator '  Summary:'

        text.each_line do |line|
          line = line.strip

          self.separator "    #{line}" unless line.empty?
        end

        self.separator ''
        return self
      end

      #
      # Adds a defaults section with the specified _flags_.
      #
      def defaults(*flags)
        self.separator '  Defaults:'

        flags.each { |flag| self.separator "    #{flag}" }

        self.separator ''
        return self
      end

      #
      # Prints the help message and exits successfully. If a _block_ is
      # given it will be called after the help message has been print
      # and before the Program has exited.
      #
      def help(&block)
        Program.success { puts self }
      end

      def parse(argv,&block)
        args = super(argv)

        block.call(args) if block
        return args
      end

    end
  end
end
