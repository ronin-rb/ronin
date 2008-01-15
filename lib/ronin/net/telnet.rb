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

require 'net/telnet'
require 'net/telnets'

module Ronin
  module Net
    module Telnet
      def telnet(options={},&block)
        sess_opts = {}
        sess_opts['Host'] = options[:host]
        sess_opts['Port'] = (options[:port] || 23)
        sess_opts['Timeout'] = (options[:timeout] || 10)
        sess_opts['Prompt'] = (options[:prompt] || /[$%#>] \z/n)

        user = options[:user]
        passwd = options[:passwd]

        if options[:ssl]
          sess_opts['CertFile'] = options[:ssl][:certfile]
          sess_opts['KeyFile'] = options[:ssl][:keyfile]
          sess_opts['CAFile'] = options[:ssl][:cafile]
          sess_opts['CAPath'] = options[:ssl][:capath]
          sess_opts['VerifyMode'] = (options[:ssl][:verify] || SSL::VERIFY_PEER)
          sess_opts['VerifyCallback'] = options[:ssl][:verify_callback]
        end

        sess = Net::Telnet.new(sess_opts)
        sess.login(user,passwd) if user

        block.call(sess) if block
        return sess
      end

      def telnet_session(options={},&block)
        telnet(options) do |sess|
          block.call(sess) if block
          sess.close
        end

        return nil
      end
    end
  end
end
