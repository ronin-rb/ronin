require 'parameters'
require 'uri'
require 'net/http'

module Ronin
  module Proto
    module HTTP
      def self.included(base)
	base.class_eval {
	  parameter :lhost, :desc => 'local hostname'
	  parameter :lport, :desc => 'local port'
	  parameter :rhost, :desc => 'remote hostname'
	  parameter :rport, :value => 80, :desc => 'remote port'

	  parameter :proxy_host, :desc => 'Proxy hostname'
	  parameter :proxy_port, :value => 8080, :desc => 'Proxy port'
	  parameter :proxy_user, :desc => 'Proxy user id'
	  parameter :proxy_pass, :desc => 'Proxy user password'
	}
      end

      def self.extended(base)
	base.instance_eval {
	  parameter :lhost, :desc => 'local hostname'
	  parameter :lport, :desc => 'local port'
	  parameter :rhost, :desc => 'remote hostname'
	  parameter :rport, :value => 80, :desc => 'remote port'

	  parameter :proxy_host, :desc => 'Proxy hostname'
	  parameter :proxy_port, :value => 8080, :desc => 'Proxy port'
	  parameter :proxy_user, :desc => 'Proxy user id'
	  parameter :proxy_pass, :desc => 'Proxy user password'
	}
      end

      def proxy(host,port=8080,user=nil,pass=nil)
	self.proxy_host = host
	self.port = port
	self.user = user
	self.pass = pass
      end

      protected

      def http_session(&block)
	unless rhost
	  raise MissingParam, "Missing '#{describe_param(:rhost)}' parameter", caller
	end

	unless rport
	  raise MissingParam, "Missing '#{describe_param(:port)}' parameter", caller
	end

	return proxify.start(rhost,rport,&block)
      end

      def http_get(path,&block)
	http_session do |http|
	  resp = http.get(path)

	  block.call(resp) if block
	  return resp
	end
      end

      def http_post(path,postdata={},&block)
	http_session do |http|
	  resp = http.post(path,postdata)

	  block.call(resp) if block
	  return resp
	end
      end
    end
  end
end
