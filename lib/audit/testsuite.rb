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
	self.clone << suite
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
