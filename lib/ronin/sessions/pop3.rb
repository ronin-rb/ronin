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
require 'ronin/network/pop3'

module Ronin
  module Sessions
    module POP3
      include Session

      setup_session do
        parameter :host, :description => 'POP3 host'
        parameter :port, :description => 'POP3 port'

        parameter :pop3_user, :description => 'POP3 user'
        parameter :pop3_password, :description => 'POP3 password'
      end

      protected

      def pop3_connect(options={},&block)
        require_params :host

        options[:port] ||= @port
        options[:user] ||= @pop3_user
        options[:password] ||= @pop3_password

        return ::Net.pop3_connect(@host,options,&block)
      end

      def pop3_session(options={},&block)
        pop3_connect(options) do |sess|
          block.call(sess) if block
          sess.finish
        end
      end
    end
  end
end
