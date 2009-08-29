#
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
#

require 'ronin/scanners/exceptions/unknown_category'
require 'ronin/extensions/meta'

require 'set'

module Ronin
  module Scanners
    module Scanner
      def self.included(base)
        base.metaclass_eval do
          #
          # The defined categories and their scanners for the class.
          #
          # @return [Hash] The categories and the scanners defined
          #                for the them within the class.
          #
          def scanners
            @scanners ||= {}
          end

          #
          # Collects all categories that the class and ancestors scan
          # for.
          #
          # @return [Set] The category names of all defined scanners.
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
          # Specifies whether or not there are scanners defined for the
          # specified category.
          #
          # @param [Symbol, String] name The name of the category to search
          #                              for scanners within.
          #
          # @return [true, false] Specifies whether there is a scanner
          #                       defined for the specified category.
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
          # Collects all scanners in the specified category.
          #
          # @param [Symbol, String] name The category name to return all
          #                              scanners for.
          #
          # @return [Array] All scanners in the specified category.
          #
          # @raise [UnknownCategory] No category has the specified name.
          #
          def scanners_in(name)
            name = name.to_sym

            unless scans_for?(name)
              raise(Ronin::Scanners::UnknownCategory,"unknown scanner category #{name}",caller)
            end

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
          # Defines a scanner in the category for the class.
          #
          # @param [Symbol, String] name The name of the category to define
          #                              the scanner for.
          # @yield [target, results, (options)] The block that will be
          #                                     called when the scanner
          #                                     is ran.
          # @yieldparam [Object] target The target object to scan.
          # @yieldparam [Proc] results A callback for enqueuing results from
          #                            the scanner in real-time.
          # @yieldparam [Hash] options Additional scanner-options that can
          #                            be used to configure the scanning.
          #
          # @example Defining a scanner for the +:lfi+ category.
          #   scanner(:lfi) do |url,results|
          #     # ...
          #   end
          #
          # @example Defining a scanner for the +:sqli+ category, that
          #          accepts additional scanner-options.
          #   scanner(:sqli) do |url,results,options|
          #     # ...
          #   end
          #
          def scanner(name,&block)
            method_name = name.to_s.downcase.gsub(/[\s\._-]+/,'_')
            name = name.to_sym

            (scanners[name] ||= []) << block

            class_def("first_#{method_name}") do |*arguments|
              options = case arguments.length
                        when 1
                          arguments.first
                        when 0
                          true
                        else
                          raise(ArgumentError,"wrong number of arguments (#{arguments.length} for 1)",caller)
                        end

              first_result = nil

              scan(name => options) do |category,result|
                first_result = result
                break
              end

              return first_result
            end

            class_def("has_#{method_name}?") do |*arguments|
              !(self.send("first_#{method_name}",*arguments).nil?)
            end

            name = name.to_s

            module_eval %{
              def #{method_name}_scan(options=true,&block)
                results = scan(:#{name.dump} => options) do |category,result|
                  block.call(result) if block
                end

                return results[:#{name.dump}]
              end
            }

            return true
          end
        end
      end

      #
      # Runs all scanners in the given categories against +each_target+.
      # If no categories are specified, all categories will be ran
      # against +each_target+.
      #
      # @param [Hash{Symbol => true,Hash}] categories
      #                                    The categories to scan for,
      #                                    with additional per-category
      #                                    scanner-options.
      #
      # @return [Hash] The results grouped by scanner category.
      #
      # @yield [category, result] The block that may receive the scanner
      #                           results for categories in real-time.
      # @yieldparam [Symbol] category The category the result belongs to.
      # @yieldparam [Object] result The result object enqueued by the
      #                             scanner.
      #
      # @example Scanning a specific category.
      #   url.scan(:rfi => true)
      #   # => {:rfi => [...]}
      #
      # @example Scanning multiple categories, with scanner-options.
      #   url.scan(:lfi => true, :sqli => {:params => ['id', 'catid']})
      #   # => {:lfi => [...], :sqli => [...]}
      #
      # @example Receiving scanner results from categories in real-time.
      #   url.scan(:lfi => true, :rfi => true) do |category,result|
      #     puts "[#{category}] #{result.inspect}"
      #   end
      #
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
            tests[name] = self.class.scanners_in(name)

            options[name] = if opts.kind_of?(Hash)
              opts
            else
              {}
            end

            results[name] = []
          end
        end

        current_category = nil
        result_callback = lambda { |result|
          results[current_category] << result
          block.call(current_category,result) if block
        }

        each_target do |target|
          tests.each do |name,scanners|
            current_category = name

            scanners.each do |scanner|
              if scanner.arity == 3
                scanner.call(target,result_callback,options[name])
              else
                scanner.call(target,result_callback)
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
      # @yield [target] The block that will be passed each target object
      #                 to be scanned.
      # @yieldparam [Object] target The target object to be scanned.
      #
      def each_target(&block)
        block.call(self)
      end
    end
  end
end
