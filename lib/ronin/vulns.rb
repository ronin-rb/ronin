#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/extensions/meta'

module Ronin
  module Vulns
    def self.included(base)
      base.metaclass_eval do
        def vuln_tests
          @vuln_tests ||= {}
        end
      end
    end

    def vuln_tests
      self.class.vuln_tests
    end

    def vulns
      vuln_tests.key
    end

    def vulns_for(name,options={})
      self.send(vuln_tests[name],options)
    end

    def vulns(options={},&block)
      all_results = []

      tests.each_key do |name|
        results = test_for(name,options)

        results.each(&block) if block
        all_results += results
      end

      return all_results
    end
  end
end
