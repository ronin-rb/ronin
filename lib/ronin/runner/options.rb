#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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

require 'optparse'
require 'ostruct'

module Ronin
  module Runner
    class Options < OpenStruct

      def initialize(prog,banner=nil,&block)
        super()

        @parser = OptionParser.new do |opts|
          if banner
            opts.banner = "usage: #{prog} #{banner}"
            opts.separator ""
          end
        end

        block.call(self) if block
      end

      def Options.command(prog,name,opts=nil,&block)
        return Options.new(prog,"#{name} #{opts}",&block) if opts
        return Options.new(prog,name,&block)
      end

      def on(*args,&block)
        @parser.on(*args,&block)
      end

      def on_verbose(&block)
        block ||= Proc.new { self.verbose = true }

        on("-v","--verbose","produce excess output",&block)
        return self
      end

      def on_help(&block)
        option("-h","--help","print this message") do |topic|
          Runner.success do
            puts @parser

            block.call(topic) if block
          end
        end

        return self
      end

      def specific(&block)
        if block
          @parser.separator "  Options:"

          block.call(self)
        end

        return self
      end

      def common(&block)
        if block
          @parser.separator "  Common Options:"

          block.call(self)
        end

        return self
      end

      def arg(name,desc)
        @parser.separator "    #{name}\t#{desc}"
        return self
      end

      def arguments(&block)
        if block
          @parser.separator "  Arguments:"

          block.call(self)

          @parser.separator ""
        end

        return self
      end

      def summary(*sum)
        @parser.separator "  Summary:"

        sum.each do |line|
          @parser.separator "    #{line}"
        end

        @parser.separator ""
        return self
      end

      def parse(argv)
        @parser.parse(argv)
      end

    end
  end
end
