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

require 'ronin/net/smtp/email'

require 'net/smtp'

module Ronin
  module Net
    module SMTP
      def smtp_agent(options={},&block)
        host = options[:host]
        port = (options[:port] || 25)

        hello = options[:hello]

        login = options[:login]
        user = options[:user]
        passwd = options[:passwd]

        return Net::SMTP.start(host,port,hello,user,passwd,login,&block)
      end

      def smtp_message(options={},&block)
        Email.new(options,&block).to_s
      end
    end
  end
end
