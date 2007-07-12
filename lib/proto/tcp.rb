require 'parameters'
require 'socket'

module Ronin
  module Proto
    module TCP
      include Parameters

      def TCP.included(klass)
	klass.parameters :lhost, :desc => 'local host'
	klass.parameters :lport, :desc => 'local port'

	klass.parameters :rhost, :desc => 'remote host'
	klass.parameters :rport, :desc => 'remote port'
      end

      protected

      def tcp_connect(&block)
	unless rhost
	  raise MissingParam, "Missing '#{describe_param(:rhost)}' parameter", caller
	end

	unless rport
	  raise MissingParam, "Missing '#{describe_param(:rport)}' parameter", caller
	end

	return TCPSocket.new(rhost,rport,&block)
      end

      def tcp_listen(&block)
	# TODO: implement some sort of basic tcp server
      end
    end
  end
end
