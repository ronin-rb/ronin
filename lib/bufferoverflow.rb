#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'platformexploit'

module Ronin
  class BufferOverflowTarget < Target

    # Buffer length
    attr_reader :buffer_length

    # Return length
    attr_reader :return_length

    # Stack base pointer
    attr_reader :bp

    # Instruction Pointer
    attr_reader :ip

    def initialize(product_version,platform,buffer_length,return_length,bp,ip,comments="")
      super(product_version,platform,comments)
      @buffer_length = buffer_length
      @return_length = return_length
      @bp = bp
      @ip = ip
    end

  end

  class BufferOverflow < PlatformExploit

    def initialize(advisory=nil)
      builder do |bof|
	bof.data = bof.prefix+build_buffer(get_target,payload.to_s)+bof.postfix
      end

      super(advisory)
    end

    def build_buffer(target=get_target,payload_str="")
      if payload_str.length>target.buffer_length
        raise PayloadSize, "the payload specified is too large for the target's buffer length", caller
      end

      buffer = pad*((target.buffer_length-payload_str.length)/pad.length)

      pad_remaining = ((target.buffer_length-payload_str.length) % pad.length)
      buffer+=pad[0,pad_remaining] unless pad_remaining==0

      buffer+=payload_str

      ip_packed = target.ip.pack(target.platform.arch)
      unless target.bp==0
	buffer+=(target.bp.pack(target.platform.arch)+ip_packed)*target.return_length.times
      else
        buffer+=ip_packed*(target.return_length*2)
      end

      return buffer
    end

  end
end
