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

require 'ronin/network/extensions/smtp'

module Net
  #
  # See <tt>Ronin::Network::SMTP.message</tt>.
  #
  def Net.esmtp_message(options={},&block)
    Net.smtp_message(options,&block)
  end

  #
  # Connects to the ESMTP server on the specified _host_ with the given
  # _options_. If a _block_ is given it will be passed the newly created
  # <tt>Net::SMTP</tt> object.
  #
  # _options_ may contain the following keys:
  # <tt>:port</tt>:: The port to connect to, defaults to
  #                  <tt>Ronin::Network::SMTP.default_port</tt>.
  # <tt>:helo</tt>:: The HELO domain.
  # <tt>:auth</tt>:: The type of authentication to use. Can be
  #                  either <tt>:login</tt>, <tt>:plain</tt> or
  #                  <tt>:cram_md5</tt>.
  # <tt>:user</tt>:: The user name to authenticate with.
  # <tt>:password</tt>:: The password to authenticate with.
  #
  def Net.esmtp_connect(host,options={},&block)
    Net.smtp_connect(host,options) do |sess|
      sess.esmtp = true
      block.call(sess)
    end
  end

  #
  # Connects to the ESMTP server on the specified _host_ with the given
  # _options_. If a _block_ is given it will be passed the newly created
  # <tt>Net::SMTP</tt> object. After the <tt>Net::SMTP</tt> object has been
  # passed to the _block_ it will be closed.
  #
  def Net.esmtp_session(host,options={},&block)
    Net.smtp_session(host,options) do |sess|
      sess.esmtp = true
      block.call(sess)
    end
  end
end
