require 'og'

module Ronin
  module Vuln
    module Descriptive

      attr_reader :name, String, :unique => true

      attr_reader :description, String

      def ==(other)
	@name==other.name
      end

      def <=>(other)
	@name<=>other.name
      end

      def to_s
	@name.to_s
      end

    end
  end
end
