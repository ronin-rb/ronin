#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/network/smtp'

module Ronin
  module Sessions
    module SMTP
      include Session

      setup_session do
        parameter :host, :description => 'SMTP host'
        parameter :port, :description => 'SMTP port'

        parameter :smtp_login, :description => 'SMTP login'
        parameter :smtp_user, :description => 'SMTP user'
        parameter :smtp_password, :description => 'SMTP password'
      end

      protected

      def smtp_message(options={},&block)
        Network::SMTP.message(options,&block)
      end

      def smtp_connect(options={},&block)
        require_params :host

        options[:port] ||= @port
        options[:login] ||= @smtp_login
        options[:user] ||= @smtp_user
        options[:password] ||= @smtp_password

        return ::Net.smtp_connect(@host,options,&block)
      end

      def smtp_session(options={},&block)
        smtp_connect(options) do |sess|
          block.call(sess) if block
          sess.close
        end
      end
    end
  end
end
