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

require 'ronin/parameters'
require 'ronin/audit/report'

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
        # setup the test
        setup

        # perform the test and collect the report
        report = perform

        # teardown the test
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
