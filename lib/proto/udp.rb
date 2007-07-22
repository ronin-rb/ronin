require 'parameters'
require 'socket'

module Ronin
  module Proto
    module UDP
      include Parameters

      def self.included(klass)
	klass.parameter :lhost, :desc => 'local host'
	klass.parameter :lport, :desc => 'local port'

	klass.parameter :rhost, :desc => 'remote host'
	klass.parameter :rport, :desc => 'remote port'
      end

      def self.extended(obj)
	obj.parameter :lhost, :desc => 'local host'
	obj.parameter :lport, :desc => 'local port'

	obj.parameter :rhost, :desc => 'remote host'
	obj.parameter :rport, :desc => 'remote port'
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
