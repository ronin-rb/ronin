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
          @vuln_tests ||= []
        end

        def has_vuln_test?(name)
          name = name.to_sym

          self.ancestors.each do |ancestor|
            if ancestor.included?(Vulns)
              return true if ancestor.vuln_tests.include?(name)
            end
          end

          return false
        end

        protected

        def vuln_test(name)
          unless has_vuln_test?(name)
            self.vuln_tests << name.to_sym
          end

          return self
        end
      end
    end

    def each_vuln_test(&block)
      self.class.ancestors.each do |ancestor|
        if ancestor.included?(Vulns)
          ancestor.vuln_tests.each(&block)
        end
      end

      return self
    end

    def vulns(options={},&block)
      all_results = []

      each_vuln_test do |test_method|
        results = send(test_method,options)

        results.each(&block) if block
        all_results += results
      end

      return all_results
    end
  end
end
