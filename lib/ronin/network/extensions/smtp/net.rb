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

require 'ronin/network/smtp/email'

require 'net/smtp'

module Net
  def Net.smtp_message(options={},&block)
    Ronin::Network::SMTP::Email.new(options,&block).to_s
  end

  def Net.smtp_connect(host,options={},&block)
    port = (options[:port] || Ronin::Network::SMTP.default_port)

    hello = options[:hello]

    login = options[:login]
    user = options[:user]
    passwd = options[:passwd]

    sess = Net::SMTP.start(host,port,hello,user,passwd,login)

    block.call(sess) if block
    return sess
  end

  def Net.smtp_session(host,options={},&block)
    Net.smtp_connect(host,options) do |sess|
      block.call(sess) if block
      sess.close
    end

    return nil
  end
end
