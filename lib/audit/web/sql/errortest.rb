require 'audit/web/sql/injectiontest'
require 'audit/web/sql/errorreport'

module Ronin
  module Audit
    module Web
      module SQL
	class ErrorTest < InjectionTest

	  parameter :platform, :desc => 'Platform to test for'
	  parameter :injection, :value => "'", :desc => 'Injection string'

	  def perform
	    report = ErrorReport.new(platform,injection,url,params,injection_params,post)
	  end

	  def ErrorTest.errors
	    @@errors ||= Hash.new { |hash,key| hash[key] = [] }
	  end

	  def errors
	    ErrorTest.errors
	  end

	  def ErrorTest.error(platform,err)
	    ErrorTest.errors[platform.to_s] << Regexp.new(err)
	  end

	  def ErrorTest.platforms
	    ErrorTest.errors.keys
	  end

	  def platforms
	    ErrorTest.platforms
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
	  
	end
      end
    end
  end
end
