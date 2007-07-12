require 'parameters'
require 'audit/test'

module Ronin
  module Audit
    class TestSuite

      include Parameters

      # Tests to perform within the suite
      attr_accessor :tests

      def initialize(tests=[])
	@tests = tests
      end

      def <<(test)
	@tests << test
      end

      def +(suite)
	self.clone+=suite
      end

      def +=(suite)
	adopt_params(suite)
	@tests+=suite.tests
	return self
      end

      def run(&block)
	reports = []

	@tests.map do |test|
	  test.adopt_params(self)
	  reports << test.run
	end
	return reports
      end

      def verify?
	run.all? { |report| report.passed? }
      end

    end
  end
end
