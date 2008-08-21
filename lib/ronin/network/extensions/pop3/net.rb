#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/network/pop3'

require 'net/pop'

module Net
  #
  # Connects to the POP3 server on the specified _host_ using the given
  # _options_. If a _block_ is given, it will be passed the newly created
  # <tt>Net::POP3</tt> object.
  #
  # _options_ may contain the following keys:
  # <tt>:port</tt>:: The port the POP3 server is running on. Defaults to
  #                  <tt>Ronin::Network::POP3.default_port</tt>.
  # <tt>:user</tt>:: The user to authenticate with when connecting to the
  #                  POP3 server.
  # <tt>:password</tt>:: The password to authenticate with when connecting
  #                      to the POP3 server.
  #
  def Net.pop3_connect(host,options={},&block)
    port = (options[:port] || Ronin::Network::POP3.default_port)
    user = options[:user]
    password = options[:password]

    sess Net::POP3.start(host,port,user,password)
    block.call(sess) if block
    return sess
  end

  #
  # Starts a session with the POP3 server on the specified _host_ using the
  # given _options_. If a _block_ is given, it will be passed the newly
  # created <tt>Net::POP3</tt> object before the connection is closed.
  #
  def Net.pop3_session(host,options={},&block)
    Net.pop3_connect(host,options) do |sess|
      block.call(sess) if block
      sess.finish
    end

    return nil
  end
end
