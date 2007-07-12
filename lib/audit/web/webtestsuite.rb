require 'audit/testsuite'

module Ronin
  module Audit
    class WebTestSuite

      parameter :url, :desc => 'URL to test'

      def initialize(tests=[])
	super(tests)
      end

    end
  end
end
