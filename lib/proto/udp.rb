require 'parameters'
require 'socket'

module Ronin
  module Proto
    module UDP
      include Parameters

      def UDP.included(klass)
	klass.parameters :lhost, :desc => 'local host'
	klass.parameters :lport, :desc => 'local port'

	klass.parameters :rhost, :desc => 'remote host'
	klass.parameters :rport, :desc => 'remote port'
      end

      protected

      def udp_connect(&block)
	unless rhost
	  raise MissingParam, "Missing '#{describe_param(:rhost)}' parameter", caller
	end

	unless rport
	  raise MissingParam, "Missing '#{describe_param(:rport)}' parameter", caller
	end

	return UDPSocket.new(rhost,rport,&block)
      end

      def udp_listen(&block)
	# TODO: implement some sort of basic udp server
      end
    end
  end
end
