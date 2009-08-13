#
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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
#

require 'ronin/network/imap'

require 'net/imap'

module Net
  #
  # Connects to the IMAP server on the specified _host_ with the given
  # _options_. If a _block_ is given, it will be passed the newly created
  # Net::Imap object.
  #
  # _options_ may contain the following keys:
  # <tt>:port</tt>:: The port the IMAP server is running on. Defaults to
  #                  IMAP.default_port.
  # <tt>:certs</tt>:: The path to the file containing CA certs of the server.
  # <tt>:auth</tt>:: The type of authentication to perform when connecting
  #                  to the server. May be either :login, or :cram_md5.
  # <tt>:user</tt>:: The user to authenticate as when connecting to the
  #                  server.
  # <tt>:password</tt>:: The password to authenticate with when connecting
  #                      to the server.
  # <tt>:ssl</tt>:: Indicates wether or not to use SSL when connecting to
  #                 the server.
  #
  def Net.imap_connect(host,options={},&block)
    port = (options[:port] || Ronin::Net::IMAP.default_port)
    certs = options[:certs]
    auth = options[:auth]
    user = options[:user]
    passwd = options[:password]

    if options[:ssl]
      ssl = true
      ssl_certs = options[:ssl][:certs]
      ssl_verify = options[:ssl][:verify]
    else
      ssl = false
      ssl_verify = false
    end

    sess = Net::IMAP.new(host,port,ssl,ssl_certs,ssl_verify)

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

  #
  # Starts an IMAP session with the IMAP server running on the specified
  # _host_ with the given _options_. If a _block_ is given, it will be
  # called before the session is closed.
  #
  def Net.imap_session(host,options={},&block)
    Net.imap_connect(host,options) do |sess|
      block.call(sess) if block
      sess.logout if options[:user]
      sess.close
      sess.disconnect
    end

    return nil
  end
end
