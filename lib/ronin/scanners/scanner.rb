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
  module Scanners
    module Scanner
      def self.included(base)
        base.metaclass_eval do
          #
          # Returns the +Hash+ of scanners defined for the class.
          #
          def scanners
            @scanners ||= {}
          end

          #
          # Returns the category names of all defined scanners.
          #
          def scans_for
            names = Set[]

            ancestors.each do |ancestor|
              if ancestor.include?(Ronin::Scanners::Scanner)
                names += ancestor.scanners.keys
              end
            end

            return names
          end

          #
          # Returns +true+ if there is a scanner with the specified category
          # _name_ was defined, returns +false+ otherwise.
          #
          def scans_for?(name)
            name = name.to_sym

            ancestors.each do |ancestor|
              if ancestor.include?(Ronin::Scanners::Scanner)
                return true if ancestor.scanners.has_key?(name)
              end
            end

            return false
          end

          #
          # Returns all scanner tests in the specified _category_.
          #
          def scanners_for(name)
            name = name.to_sym
            tests = []

            ancestors.each do |ancestor|
              if ancestor.include?(Ronin::Scanners::Scanner)
                if ancestor.scanners.has_key?(name)
                  tests += ancestor.scanners[name]
                end
              end
            end

            return tests
          end

          #
          # Defines a scanner with the specified category _name_ and
          # _block_.
          #
          # When scanning against a target, an +Array+ of results collected
          # thus far and the target object to be scanned will be passed to
          # the _block_.
          #
          #   scanner(:lfi) do |url,results|
          #     ...
          #   end
          #
          # If the scanner accepts a 3rd argument, it will be passed a
          # +Hash+ of configuration options when the scanner is called.
          #
          #   scanner(:sqli) do |url,results,options|
          #     ...
          #   end
          #
          def scanner(name,&block)
            name = name.to_sym

            (scanners[name] ||= []) << block

            class_def("#{name}_scan") do |*arguments|
              options = case arguments.length
              when 1
                arguments.first
              when 0
                true
              else
                raise(ArgumentError,"wrong number of arguments (#{arguments.length} for 1)",caller)
              end

              scan(name => options)
            end

            return true
          end
        end
      end

      def scan(categories={},&block)
        tests = {}
        options = {}
        results = {}

        if categories.empty?
          self.class.scans_for.each { |name| categories[name] = true }
        end

        categories.each do |name,opts|
          name = name.to_sym

          if opts
            tests[name] = self.class.scanners_for(name)

            if opts.kind_of?(Hash)
              options[name] = opts
            else
              options[name] = {}
            end

            results[name] = []
          end
        end

        each_target do |target|
          tests.each do |name,scanners|
            scanners.each do |scanner|
              if scanner.arity == 3
                scanner.call(target,results[name],options[name])
              else
                scanner.call(target,results[name])
              end
            end
          end
        end

        return results
      end

      protected

      #
      # A place holder method which will call the specified _block_ with
      # each target object to be scanned. By default, the method will call
      # the specified _block_ once, simply passing it the +self+ object.
      #
      def each_target(&block)
        block.call(self)
      end
    end
  end
end
