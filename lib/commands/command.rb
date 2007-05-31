module Ronin
  module Commands
    class Command

      # Official name of the command
      attr_reader :name

      # Other short names of the command
      attr_reader :short_names

      # Command block
      attr_reader :block

      def initialize(name,*short_names,&block)
	@name = name
	@short_names = short_names
	@block = block
      end

      def run(argv)
	@block.call(argv)
      end

      def to_s
	str = @name
	unless @short_names.empty?
	  str+=" "+@short_names.join(', ')
	end
	return str
      end

    end
  end
end
