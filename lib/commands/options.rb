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
