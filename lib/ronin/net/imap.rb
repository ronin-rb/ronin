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

require 'net/imap'

module Ronin
  module Net
    module IMAP
      DEFAULT_PORT = 143 # Default imap port

      def IMAP.connect(host,options={},&block)
        port = (options[:port] || DEFAULT_PORT)
        certs = options[:certs]
        auth = options[:auth]
        user = options[:user]
        passwd = options[:passwd]

        if options[:ssl]
          ssl = true
          ssl_certs = options[:ssl][:certs]
          ssl_verify = options[:ssl][:verify]
        else
          ssl = false
          ssl_verify = false
        end

        sess = ::Net::IMAP.new(host,port,ssl,ssl_certs,ssl_verify)

        if user
          if auth==:cram_md5
            sess.authenticate('CRAM-MD5',user,passwd)
          else
            sess.authenticate('LOGIN',user,passwd)
          end
        end

        block.call(sess) if block
        return sess
      end

      def IMAP.session(host,options={},&block)
        IMAP.connect(host,options) do |sess|
          block.call(sess) if block
          sess.close
          sess.logout
        end

        return nil
      end
    end
  end
end
