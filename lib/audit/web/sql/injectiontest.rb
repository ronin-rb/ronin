require 'audit/web/webtest'
require 'audit/web/sql/sqlreport'

module Ronin
  module Audit
    module Web
      module SQL
	class InjectionTest < WebTest

	  parameter :url, :desc => 'URL to inject'
	  parameter :post, :value => false, :desc => 'POST or GET the URL'

	  parameter :params, :value => {}, :desc => 'Parameters to test'
	  parameter :injection_params, :value => [], :desc => 'Parameters to inject'

	  def initialize(&block)
	    super(&block)
	  end

	  def param(name,value=nil)
	    params[name.to_s] = value
	  end

	  def perform
	    SQLReport.new
	  end

	  protected

	  def inject(injection,&block)
	    base = parse_url_base(url)

	    unless post
	      url_params = parse_url_params(url).merge(params)

	      inject_url(injection,base,url_params,injection_params) do |param,injection_url|
		block.call(param,get_url(injection_url))
	      end
	    else
	      inject_params(injection,params,injection_params) do |param,params|
		block.call(param,post_url(url,params))
	      end
	    end
	  end

	  def inject_url(injection,base,params,inject_params=[],&block)
	    inject_params(injection,params,inject_params) do |param,params|
	      block.call(param,build_url(base,params))
	    end
	  end

	  def inject_params(injection,params,inject_params=[],&block)
	    replace = lambda { |param|
	      new_params = params.clone
	      new_params[param] = injection
	      new_params
	    }

	    unless inject_params.empty?
	      inject_params.each do |name|
		block.call(name,replace.call(name))
	      end
	    else
	      params.each_key do |param|
		block.call(param,replace.call(param))
	      end
	    end
	  end

	  def build_url(base,params)
	    "#{base}?"+params.to_a.map { |param| "#{param[0]}=#{param[1]}" }.join('&')
	  end

	  def parse_url_base(url)
	    index = url.index('?')
	    if index
	      return url[0,index]
	    else
	      return url
	    end
	  end

	  def parse_url_params(url)
	    url_params = {}

	    index = url.index('?')
	    if index
	      url[index+1,url.length].split('&').each do |param|
		sub_index = param.index('=')

		if sub_index
		  name = param[0,sub_index]
		  url_params[name] = param[sub_index+1,param.length]
		else
		  url_params[param] = nil
		end
	      end
	    end
	    return url_params
	  end

	end
      end
    end
  end
end
