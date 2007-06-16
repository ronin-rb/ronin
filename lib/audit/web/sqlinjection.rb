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

	def inject
	  if @injection
	    return "#{@name}=#{@injection}"
	  elsif @value
	    return "#{@name}=#{@value}"
	  else
	    return @name
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

	# Classic single-quote
	SINGLE_QUOTE = "'"

	# Classic or-true SQL expression
	OR_TRUE = "' or '1'='1"

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

	  parse_url(url)
	  parse_url_params(url)
	  params.each { |name,value| @params[name.to_s].value = value }

	  @injection = SINGLE_QUOTE
	  @auditors = {}

	  @platform = nil

	  block.call(self) if block
	end

	def SQLInjection.errors
	  @@errors ||= Hash.new { |hash,key| hash[key] = [] }
	end

	def SQLInjection.was_injected?(body,platform=nil)
	  if platform
	    SQLInjection.errors[platform.to_s].each do |pattern|
	      return true if body =~ pattern
	    end
	  else
	    SQLInjection.errors.each_value do |platform|
	      platform.each do |pattern|
		return true if body =~ pattern
	      end
	    end
	  end

	  return false
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

	def inject_param(name)
	  name = name.to_s
	  params = @params.value.map do |param|
	    if param.name==name
	      param.inject
	    else
	      param.to_s
	    end
	  end

	  return @url+'?'+params.join('&')
	end

	def audit_param(name,body)
	  name = name.to_s
	  if @auditors.has_key?(name)
	    return @auditors[name].call(body)
	  else
	    return SQLInjection.was_injected?(body,@platform)
	  end
	end

	def audit
	  injectable = []

	  test_param = lambda { |param|
	    url = URI.parse(inject_param(param.name))
	    res = Net::HTTP.start(url.host,url.port) do |http|
	      http.get(url.path)
	    end

	    if audit_param(param.name,res.body)
	      injectable << param.name
	    end
	  }

	  injections = @params.values.map { |param| param.injection!=nil }
	  unless injections.empty?
	    injections.each do |param|
	      test_param(param)
	    end
	  else
	    @params.each_value do |param|
	      test_param(param)
	    end
	  end

	  return injectable
	end

	def to_s
	  return @url+'?'+@params.value.join('&')
	end

	protected

	def parse_url(url)
	  index url.index('?')
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
	      @params[param[0,sub_index]].value = param[sub_index+1,param.length]
	    end

	    @params[param].injection = @injection
	  end
	end

      end
    end
  end
end
