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

require 'ronin/program/program'

require 'optparse'
require 'ostruct'

module Ronin
  module Program
    class Options

      # Settings used by the options
      attr_reader :settings

      #
      # Creates a new Options object with the specified _program_ name
      # and the given _banner_. If a _block_ is given, it will be passed
      # the newly created Options object.
      #
      def initialize(program,banner=nil,&block)
        @settings = OpenStruct.new
        @settings.verbose = false

        @help_block = proc { help }

        @verbose_block = proc {
          @settings.verbose = true
        }

        @parser = OptionParser.new do |opts|
          if banner
            opts.banner = "Usage: #{program} #{banner}"
            opts.separator ''
          end
        end

        block.call(self) if block
      end

      #
      # Creates a new Options object for a Command with the specified
      # _program_ name, command _name_ and the given _banner_. If a _block_
      # is given, it will be passed the newly created Options object.
      #
      def Options.command(program,name,banner=nil,&block)
        return Options.new(program,"#{name} #{banner}",&block) if banner
        return Options.new(program,name,&block)
      end

      #
      # Call the specified _block_ when the given option _flags_ are parsed.
      #
      def on(*flags,&block)
        @parser.on(*flags,&block)
        return self
      end

      #
      # Calls the specified _block_ when the verbose option flag is parsed.
      #
      def on_verbose(&block)
        @verbose_block = block
        return self
      end

      #
      # Calls the specified _block_ when the help option-flag is parsed.
      #
      def on_help(&block)
        @help_block = block
        return self
      end

      #
      # Adds a section separator with the specified _text_.
      #
      def separator(text)
        @parser.separator(text)
        return self
      end

      #
      # Adds an options section to the help message. If a _block_ is given
      # it will be called before any default options are added.
      #
      def options(&block)
        @parser.separator '  Options:'

        block.call(self) if block

        @parser.on('-v','--verbose','produce excess output',&(@verbose_block))
        @parser.on('-h','--help','print this message',&(@help_block))
        @parser.separator ''

        return self
      end

      #
      # Adds an the argument with the specified _name_ and _description_
      # to the arguments section of the help message of these options.
      #
      def arg(name,description)
        @parser.separator "    #{name}\t#{description}"
        return self
      end

      #
      # Creates an arguments section in the help message and calls the
      # given _block_.
      #
      def arguments(&block)
        if block
          @parser.separator '  Arguments:'

          block.call(self)

          @parser.separator ''
        end

        return self
      end

      #
      # Addes a summary section with the specified _lines_.
      #
      def summary(*lines)
        @parser.separator '  Summary:'

        lines.each { |line| @parser.separator "    #{line}" }

        @parser.separator ''
        return self
      end

      #
      # Adds a defaults section with the specified _flags_.
      #
      def defaults(*flags)
        @parser.separator '  Defaults:'

        flags.each { |flag| @parser.separator "    #{flag}" }

        @parser.separator ''
        return self
      end

      #
      # Prints the help message and exits successfully. If a _block_ is
      # given it will be called after the help message has been print
      # and before the Program has exited.
      #
      def help(&block)
        Program.success do
          puts @parser

          block.call(self) if block
        end
      end

      #
      # Parses the specified _argv_ Array. If a _block_ is given it will
      # be passed the left-over arguments. Returns the left-over arguments.
      #
      def parse(argv,&block)
        args = @parser.parse(argv)

        block.call(self,args) if block
        return args
      end

      #
      # Returns a String representation of the OptParse parser.
      #
      def to_s
        @parser.to_s
      end

    end
  end
end
