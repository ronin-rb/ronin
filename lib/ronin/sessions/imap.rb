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
require 'ronin/network/imap'

module Ronin
  module Sessions
    module IMAP
      include Session

      IMAP_SESSION = proc do
        parameter :imap_host, :description => 'IMAP host'
        parameter :imap_port, :description => 'IMAP port'

        parameter :imap_auth, :description => 'IMAP authentication mode'
        parameter :imap_user, :description => 'IMAP user'
        parameter :imap_password, :description => 'IMAP password'
      end

      def self.included(base)
        Session.setup_class(base,&IMAP_SESSION)
      end

      def self.extended(obj)
        Session.setup_object(obj,&IMAP_SESSION)
      end

      protected

      def imap_connect(options={},&block)
        unless @imap_host
          raise(ParamNotFound,"Missing parameter '#{describe_param(:imap_host)}'",caller)
        end

        options[:port] ||= @imap_port
        options[:auth] ||= @imap_auth
        options[:user] ||= @imap_user
        options[:password] ||= @imap_password

        return ::Net.imap_connect(@imap_host,options,&block)
      end

      def imap_session(options={},&block)
        imap_connect(options) do |sess|
          block.call(sess) if block
          sess.close
          sess.logout
        end
      end
    end
  end
end
