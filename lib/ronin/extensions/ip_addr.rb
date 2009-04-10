#
#--
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
#++
#

require 'ipaddr'

class IPAddr

  include Enumerable

  def IPAddr.each(cidr_or_range,&block)
    if cidr_or_range =~ /::/
      separator = '::'
      base = 16
    else
      separator = '.'
      base = 10
    end

    if (cidr_or_range.include?('*') || cidr_or_range.include?('-'))
      ranges = cidr_or_range.split(separator).map do |n|
        if n == '*'
          (1..254)
        elsif n.include?('-')
          start, stop = n.split('-',2).map { |i| i.to_i(base) }

          (start..stop)
        else
          n.to_i(base)
        end
      end
    else
      return IPAddr.new(cidr_or_range).each(&block)
    end
  end

  #
  # Iterates over each IP address that is included in the addresses mask,
  # passing each to the given _block_.
  #
  def each(&block)
    case @family
    when Socket::AF_INET
      family_mask = IN4MASK
    when Socket::AF_INET6
      family_mask = IN6MASK
    end

    if block
      (0..((~@mask_addr) & family_mask)).each do |i|
        block.call(_to_string(@addr | i))
      end
    end

    return self
  end

end
