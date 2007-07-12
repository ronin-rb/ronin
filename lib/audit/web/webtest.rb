require 'audit/test'
require 'proto/web'

module Ronin
  module Audit
    class WebTest < Test

      include Proto::Web

      # TODO: integrate in basic/digest authentication
      parameter :basic_auth_user, :desc => 'HTTP Basic Authentication user id'
      parameter :basic_auth_pass, :desc => 'HTTP Basic Authentication user password'

      def initialize(&block)
	super(&block)
      end

    end
  end
end
