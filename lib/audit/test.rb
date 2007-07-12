require 'parameters'
require 'audit/report'

module Ronin
  module Audit
    class Test

      include Parameters

      def initialize(&block)
	block.call(self) if block
      end

      def setup
	# place holder
      end

      def perform
	# place holder
	Report.new
      end

      def teardown
	# place holder
      end

      def run
	setup

	report = Report.start
	perform(report)
	report.stop

	teardown
	return report
      end

      def passed?
	run.passed
      end

      def failed?
	!(run.passed)
      end

    end
  end
end
