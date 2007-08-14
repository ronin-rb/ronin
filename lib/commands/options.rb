#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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
#

require 'optparse'
require 'ostruct'

module Ronin
  module Commands
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

      def Options.sub_command(prog,name,opts=nil,&block)
	return Options.new(prog,"#{name} #{opts}",&block) if opts
	return Options.new(prog,name,&block)
      end

      def option(*args,&block)
	@parser.on(*args,&block)
      end

      def verbose_option(&block)
	if block
	  option("-v","--verbose","produce excess output",&block)
	else
	  option("-v","--verbose","produce excess output") do
	    verbose = true
	  end
	end
      end

      def version_option(&block)
	option("-V","--version","print the version",&block)
      end

      def help_option(&block)
	if block
	  option("-h","--help","print this message",&block)
	else
	  option("-h","--help","print this message") do
	    puts @parser
	    exit
	  end
	end
      end

      def specific(&block)
	@parser.separator "  Options:"

	verbose_option
	help_options

	block.call(self) if block
      end

      def common(&block)
	@parser.separator "  Common Options:"
	block.call(self) if block
      end

      def arguments(&block)
	@parser.separator "  Arguments:"

	def arg(name,desc)
	  @parser.separator "    #{name}\t#{desc}"
	end

	instance_eval(&block) if block
	@parser.separator ""
      end

      def summary(*sum,&block)
	@parser.separator "  Summary:"
	for line in sum
	  @parser.separator "    #{line}"
	end
	@parser.separator ""
      end

      def parse(argv)
	@parser.parse(argv)
      end

    end
  end
end
