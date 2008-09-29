#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/sessions/session'
require 'ronin/network/esmtp'

module Ronin
  module Sessions
    module ESMTP
      include Session

      setup_session do
        parameter :esmtp_host, :description => 'ESMTP host'
        parameter :esmtp_port, :description => 'ESMTP port'

        parameter :esmtp_login, :description => 'ESMTP login'
        parameter :esmtp_user, :description => 'ESMTP user'
        parameter :esmtp_password, :description => 'ESMTP password'
      end

      protected

      def esmtp_message(options={},&block)
        Network::SMTP.message(options,&block)
      end

      def esmtp_connect(options={},&block)
        unless @esmtp_host
          raise(ParamNotFound,"Missing parameter #{describe_param(:esmtp_host).dump}",caller)
        end

        options[:port] ||= @esmtp_port
        options[:login] ||= @esmtp_login
        options[:user] ||= @esmtp_user
        options[:password] ||= @esmtp_password

        return ::Net.esmtp_connect(@esmtp_host,options,&block)
      end

      def esmtp_session(options={},&block)
        esmtp_connect(options) do |sess|
          block.call(sess) if block
          sess.close
        end
      end
    end
  end
end
