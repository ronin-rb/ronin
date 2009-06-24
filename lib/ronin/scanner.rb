#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'set'

module Ronin
  module Scanner
    def self.included(base)
      base.metaclass_eval do
        def scanners
          @scanners ||= Hash.new { |hash,key| hash[key] = [] }
        end

        def scans_for
          names = Set[]

          ancestors.each do |ancestor|
            if ancestor.kind_of?(Ronin::Scanner)
              names += ancestor.scanners.keys
            end
          end

          return names
        end

        def scans_for?(name)
          name = name.to_sym

          ancestors.each do |ancestor|
            if ancestor.kind_of?(Ronin::Scanner)
              return true if ancestor.scanners.has_key?(name)
            end
          end

          return false
        end

        def scanner(name,&block)
          scanners[name.to_sym] << block
        end

        def scan_target(name,*target)
          name = name.to_sym
          results = []

          ancestors.each do |ancestor|
            if ancestor.kind_of?(Ronin::Scanner)
              if ancestor.scanners.has_key?(name)
                ancestor.scanners[name].each do |block|
                  block.call(results,*target)
                end
              end
            end
          end

          return results
        end
      end
    end

    def scan(tests={},&block)
      results = {}

      tests.each do |name,mode|
        results[name.to_sym] = [] if mode
      end

      each_target do |*target|
        tests.each do |name,mode|
          if mode
            results[name] += self.class.scan_target(name,*target)
          end
        end
      end

      return results
    end

    protected

    def each_target(&block)
    end
  end
end
