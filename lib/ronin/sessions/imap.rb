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

require 'ronin/network/imap'

module Ronin
  module Sessions
    module IMAP
      protected

      def imap_connect(options={},&block)
        unless @host
        end

        options[:port] ||= @port
        options[:auth] ||= @imap_auth
        options[:user] ||= @imap_user
        options[:password] ||= @imap_password

        return ::Net.imap_connect(@host,options,&block)
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
