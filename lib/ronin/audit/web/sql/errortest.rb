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

require 'ronin/audit/web/sql/injectiontest'
require 'ronin/audit/web/sql/errorreport'

module Ronin
  module Audit
    module Web
      module SQL
        class ErrorTest < InjectionTest

          parameter :platform, :desc => 'Platform to test for'
          parameter :injection, :value => "'", :desc => 'Injection string'

          def inject
          end

          def perform
            ErrorReport.new(platform,injection,url,test_params,inject_params,post) do |report|
              inject(injection) do |param,resp|
                report.injectable_params << param if has_error?(resp)
              end
            end
          end

          def self.errors
            @@errors ||= Hash.new { |hash,key| hash[key] = [] }
          end

          def errors
            self.errors
          end

          def self.error(platform,err)
            self.errors[platform.to_s] << Regexp.new(err)
          end

          def self.platforms
            self.errors.keys
          end

          def platforms
            self.platforms
          end

          # Default set of SQL Injection errors to search for.
          # Adapted from SQL injection digger (http://sqid.rubyforge.org/)
          error('Microsoft','Microsoft OLE DB Provider for SQL Server')
          error('Microsoft','\[Microsoft\]\[ODBC Microsoft Access Driver\] Syntax error')
          error('Microsoft','Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC SQL Server Driver\]')
          error('Microsoft','Microsoft OLE DB Provider for ODBC Drivers.*\[Microsoft\]\[ODBC Access Driver\]')
          error('Microsoft','Microsoft JET Database Engine')
          error('Microsoft','ADODB.Command.*error')
          error('Microsoft','Microsoft VBScript runtime')
          error('Microsoft','Type mismatch')

          error('ASP.Net','Server Error.*System\.Data\.OleDb\.OleDbException')

          error('JSP','Invalid SQL statement or JDBC')
          error('JSP','javax\.servlet\.ServletException')

          error('MySQL','Warning.*supplied argument is not a valid MySQL result')
          error('MySQL','You have an error in your SQL syntax.*(on|at) line')
          error('MySQL','Warning.*mysql_.*\(\)')

          error('Oracle','ORA-[[:digit:]]{4}')

          error('Tomcat','org\.apache\.jasper\.JasperException')

          error('PHP','Warning.*failed to open stream')
          error('PHP','Fatal Error.*(on|at) line')

          protected

          def has_error?(resp)
            platform_test = lambda { |platform|
              ErrorTest.errors[platform].each do |pattern|
                return true if resp =~ Regexp.new(pattern)
              end
            }

            if platform
              return platform_test.call(platform)
            else
              ErrorTest.platforms.each do |platform|
                return true if platform_test.call(platform)
              end
            end

            return false
          end

        end
      end
    end
  end
end
