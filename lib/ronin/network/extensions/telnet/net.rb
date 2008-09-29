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

require 'ronin/network/telnet'

require 'net/telnet'
require 'net/telnets'

module Net
  #
  # Creates a new Telnet object with the specified _host_, given port
  # and the given _options_. If a _block_ is given, it will be passed
  # the newly created Telnet object.
  #
  # _options_ may contain the following keys:
  # <tt>:port</tt>:: The port to connect to. Defaults to
  #                  <tt>Ronin::Network::Telnet.default_port</tt>, if not
  #                  given.
  # <tt>:binmode</tt>:: Indicates that newline substitution shall not
  #                     be performed.
  # <tt>:output_log</tt>:: The name of the file to write connection
  #                        status messages and all received traffic to.
  # <tt>:dump_log</tt>:: Similar to the <tt>:output_log</tt> option,
  #                      but connection output is also written in
  #                      hexdump format.
  # <tt>:prompt</tt>:: A regular expression matching the host's
  #                    command-line prompt sequence, used to determine
  #                    when a command has finished. Defaults to
  #                    <tt>Ronin::Network::Telnet.default_prompt</tt>, if
  #                    not given.
  # <tt>:telnet</tt>:: Indicates that the connection shall behave as a
  #                    telnet connection. Defaults to +true+.
  # <tt>:plain</tt>:: Indicates that the connection shall behave as a
  #                   normal TCP connection.
  # <tt>:timeout</tt>:: The number of seconds to wait before timing out
  #                     both the initial attempt to connect to host,
  #                     and all attempts to read data from the host.
  #                     Defaults to
  #                     <tt>Ronin::Network::Telnet.default_timeout</tt>,
  #                     if not given.
  # <tt>:wait_time</tt>:: The amount of time to wait after seeing what
  #                       looks like a prompt.
  # <tt>:proxy</tt>:: A proxy object to used instead of opening a
  #                   direct connection to the host. Must be either
  #                   another telnet object or an IO object.
  #                   Defaults to
  #                   <tt>Ronin::Network::Telnet.proxy</tt>, if not given.
  # <tt>:user</tt>:: The user to login with.
  # <tt>:password</tt>:: The password to login with.
  # <tt>:ssl</tt>:: A Hash of SSL information to use for a SSLed
  #                 Telnet session. This hash must contain the following
  #                 keys.
  #                 <tt>:certfile</tt>:: The SSL Certfile to use.
  #                 <tt>:keyfile</tt>:: The SSL Key file to use.
  #                 <tt>:cafile</tt>:: The SSL CAFile to use.
  #                 <tt>:capath</tt>:: The SSL CAPath to use.
  #
  #   Telnet.connect('towel.blinkenlights.nl') # => Telnet
  #
  def Net.telnet_connect(host,options={},&block)
    sess_opts = {}
    sess_opts['Host'] = host
    sess_opts['Port'] = (options[:port] || Ronin::Network::Telnet.default_port)
    sess_opts['Binmode'] = options[:binmode]
    sess_opts['Output_log'] = options[:output_log]
    sess_opts['Dump_log'] = options[:dump_log]
    sess_opts['Prompt'] = (options[:prompt] || Ronin::Network::Telnet.default_prompt)

    if (options[:telnet] && !options[:plain])
      sess_opts['Telnetmode'] = true
    end

    sess_opts['Timeout'] = (options[:timeout] || Ronin::Network::Telnet.default_timeout)
    sess_opts['Waittime'] = options[:wait_time]
    sess_opts['Proxy'] = (options[:proxy] || Ronin::Network::Telnet.proxy)

    user = options[:user]
    passwd = options[:passwd]

    if options[:ssl]
      sess_opts['CertFile'] = options[:ssl][:certfile]
      sess_opts['KeyFile'] = options[:ssl][:keyfile]
      sess_opts['CAFile'] = options[:ssl][:cafile]
      sess_opts['CAPath'] = options[:ssl][:capath]
      sess_opts['VerifyMode'] = (options[:ssl][:verify] || SSL::VERIFY_PEER)
      sess_opts['VerifyCallback'] = options[:ssl][:verify_callback]
      sess_opts['VerifyDepth'] = options[:ssl][:verify_depth]
    end

    sess = Net::Telnet.new(sess_opts)
    sess.login(user,passwd) if user

    block.call(sess) if block
    return sess
  end

  #
  # Creates a new Telnet object with the specified _host, given port
  # and the given _options_. See telnet for a complete listing the
  # _options_. If a _block_ is given, it will be passed the newly
  # created Telnet object. After the telnet connection has been
  # established, and the given _block_ has completed, the connection
  # is then closed.
  #
  #   Net.telnet_session('towel.blinkenlights.nl') do |movie|
  #     movie.each_line { |line| puts line }
  #   end
  #
  def Net.telnet_session(host,options={},&block)
    Net.telnet_connect(host,options) do |sess|
      block.call(sess) if block
      sess.close
    end

    return nil
  end
end
