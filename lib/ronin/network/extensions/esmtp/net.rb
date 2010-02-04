#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  # @see Ronin::Network::SMTP.message
  #
  def Net.esmtp_message(options={},&block)
    Net.smtp_message(options,&block)
  end

  #
  # Creates a connection to the ESMTP server.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Integer] :port (Ronin::Network::SMTP.default_port)
  #   The port to connect to.
  #
  # @option options [String] :helo
  #   The HELO domain.
  #
  # @option options [Symbol] :auth
  #   The type of authentication to use. Can be either `:login`, `:plain`,
  #   or `:cram_md5`.
  #
  # @option options [String] :user
  #   The user-name to authenticate with.
  #
  # @option options [String] :password
  #   The password to authenticate with.
  #
  # @yield [session]
  #   If a block is given, it will be passed an ESMTP enabled session object.
  #
  # @yieldparam [Net::SMTP] session
  #   The ESMTP session.
  #
  # @return [Net::SMTP]
  #   The ESMTP enabled session.
  #
  def Net.esmtp_connect(host,options={},&block)
    Net.smtp_connect(host,options) do |sess|
      sess.esmtp = true
      block.call(sess)
    end
  end

  #
  # Starts an ESMTP session with the ESMTP enabled server.
  #
  # @param [String] host
  #   The host to connect to.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @yield [session]
  #   If a block is given, it will be passed an ESMTP enabled session
  #   object. After the block has returned, the session will be closed.
  #
  # @yieldparam [Net::SMTP] session
  #   The ESMTP session.
  #
  # @see Net.esmtp_connect
  #
  def Net.esmtp_session(host,options={},&block)
    Net.smtp_session(host,options) do |sess|
      sess.esmtp = true
      block.call(sess)
    end
  end
end
