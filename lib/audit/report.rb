module Ronin
  module Audit
    class Report

      # Start time of the test
      attr_reader :start_time

      # Outcome of the test
      attr_reader :status

      # Stop time of the test
      attr_reader :stop_time

      def initialize
	@status = true
      end

      def start
	@start_time = Time.now
      end

      def Report.start
	Report.new.start
      end

      def stop
	@stop_time = Time.now
      end

      def pass
	@status = true
      end

      def passed?
	@status==true
      end

      def fail
	@status = false
      end

      def failed?
	@status==false
      end

    end
  end
end
