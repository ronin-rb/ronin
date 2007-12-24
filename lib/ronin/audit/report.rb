#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Audit
    class Report

      # Start time of the test
      attr_reader :start_time

      # Outcome of the test
      attr_reader :status

      # Stop time of the test
      attr_reader :stop_time

      def initialize(&block)
        @status = true

        if block
          # begin reporting
          start

          # collect report data
          block.call(self)

          # stop reporting
          stop
        end
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
