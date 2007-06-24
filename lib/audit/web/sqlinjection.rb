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

require 'uri'
require 'net/http'

module Ronin
  module Audit
    module Web
      class SQLInjectionParameter

	# Name of parameter
	attr_reader :name

	# Default value
	attr_accessor :value

	# Injection value
	attr_accessor :injection

	def initialize(name,value=nil,injection=nil)
	  @name = name.to_s
	  @value = value
	  @injection = injection
	end

	def inject(expr=@injection)
	  if expr
	    return "#{@name}=#{expr}"
	  else
	    return self.to_s
	  end
	end

	def to_s
	  if @value
	    return "#{@name}=#{@value}"
	  else
	    return @name
	  end
	end
      end

      class SQLInjection

	# The URL through which the sql-injection occurrs
	attr_reader :url

	# Parameters
	attr_reader :params

	# Injection string
	attr_accessor :injection

	# Platform to inject upon
	attr_accessor :platform

	def initialize(url,params={},&block)
	  @params = Hash.new { |hash,key| hash[key.to_s] = SQLInjectionParameter.new(key) }

	  # parse in params from the given URL
	  url = url.to_s
	  parse_url(url)
	  parse_url_params(url)

	  # merge in specified params
	  params.each { |name,value| @params[name.to_s].value = value }

	  # set the default injection string and target all platforms
	  @injection = "'"
	  @platform = nil
	  @auditors = {}

	  block.call(self) if block
	end

	def param(name,value=nil)
	  @params[name.to_s].value = value
	end

	def auditor(name,&block)
	  @auditors[name.to_s] = block
	end

	def inject(name,value=@injection,&block)
	  @params[name.to_s].injection = value
	  auditor(name,&block) if block
	end

	def request_page(page)
	  url = URI.parse(page)
	  response = Net::HTTP.start(url.host,url.port) do |http|
	    http.get(url.path)
	  end
	  return response.body
	end

	def inject_url(param_name,value=nil)
	  params = @params.values.map do |param|
	    if param.name==param_name
	      if value
		param.inject(value)
	      elsif param.injection
		param.inject
	      else
		param.inject(@injection)
	      end
	    else
	      param.to_s
	    end
	  end

	  return @url+'?'+params.join('&')
	end

	def injectable?(page)
	  response = request_page(page)

	  if @platform
	    SQLInjection.errors[@platform.to_s].each do |pattern|
	      return true if response =~ pattern
	    end
	  else
	    SQLInjection.errors.each_value do |platform|
	      platform.each do |pattern|
		return true if response =~ pattern
	      end
	    end
	  end

	  return false
	end

	def param_injectable?(param)
	  param = param.to_s

	  url = inject_url(param)
	  if @auditors.has_key?(param)
	    return @auditors[param].call
	  else
	    return injectable?(url)
	  end
	end

	def audit
	  injectable = []

	  audit_param = lambda { |param|
	    injectable << param.name if param_injectable?(param.name)
	  }

	  injections = @params.values.select { |param| param.injection!=nil }
	  unless injections.empty?
	    injections.each { |param| audit_param.call(param) }
	  else
	    @params.each_value { |param| audit_param.call(param) }
	  end

	  return injectable
	end

	def SQLInjection.audit(url,params={},&block)
	  injection = SQLInjection.new(url,params,&block)
	  return injection.audit
	end

	def to_s
	  return @url+'?'+@params.value.join('&')
	end

	def SQLInjection.errors
	  @@errors ||= Hash.new { |hash,key| hash[key] = [] }
	end

	def errors
	  SQLInjection.errors
	end

	def SQLInjection.error(platform,err)
	  SQLInjection.errors[platform.to_s] << Regexp.new(err)
	end

	def SQLInjection.platforms
	  SQLInjection.errors.keys
	end

	def platforms
	  SQLInjection.platforms
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

	def parse_url(url)
	  index = url.index('?')
	  if index
	    @url = url[0,index]
	  else
	    @url = url
	  end
	end

	def parse_url_params(url)
	  index = url.index('?')
	  return unless index

	  url[index+1,url.length].split('&').each do |param|
	    sub_index = param.index('=')

	    if sub_index
	      name = param[0,sub_index]

	      @params[name].value = param[sub_index+1,param.length]
	    else
	      @params[param].value = nil
	    end
	  end
	end

      end
    end
  end
end
