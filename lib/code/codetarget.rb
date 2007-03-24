module Ronin
  module Code
    class CodeTarget

      # Name
      attr_reader :name

      # Ro location
      attr_reader :ro

      # Data location
      attr_reader :data

      # Text location
      attr_reader :text

      # Variables
      attr_reader :variables

      # Functions
      attr_reader :funcs

      def initialize(name,ro,data,text,variables={},funcs={})
	@name = name
	@ro = ro
	@data = data
	@text = text
	@variables = variables
	@funcs = funcs
      end

      def has_variable?(sym)
	@variables.has_key?(sym)
      end

      def variable(sym)
	@variables[sym]
      end

      def has_function?(sym)
	@funcs.has_key?(sym)
      end

      def function(sym)
	@funcs[sym]
      end

    end
  end
end
