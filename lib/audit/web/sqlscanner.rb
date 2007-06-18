require 'open-uri'
require 'hpricot'
require 'audit/web/sqlinjection'

module Ronin
  module Audit
    module Web
      class SQLInjectedLink

	# Vulnerable URL
	attr_reader :url

	# Vulnerable parameters of the URL
	attr_reader :params

	def initialize(url,params)
	  @url = url
	  @params = params
	end

	def to_s
	  @url
	end

      end

      class SQLScanner < WebCrawler

	# Platform to inject upon
	attr_reader :platform

	def initialize(targets,platform=nil)
	  super(*targets) do |crawler|
	    crawler.capture { |url| url.path.include?('?') }
	  end

	  @platform = platform
	end

	def scan(*targets,&block)
	  vulnerable = []

	  crawl(*targets) do |url|
	    params = SQLInjection.audit(url,@platform)
	    unless params.empty
	      injected = SQLInjectedLink.new(url,params)

	      vulnerable << injected
	      block.call(injected) if block
	    end
	  end

	  return vulnerable
	end

      end
    end
  end
end
