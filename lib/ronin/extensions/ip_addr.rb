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

  #
  # Iterates over the CIDR or globbed address range, passing each
  # address in the range to the specified _block_. Supports both
  # IPv4 and IPv6 address ranges.
  #
  #   IPAddr.each('10.1.1.1/24') do |ip|
  #     ...
  #   end
  #
  #   IPAddr.each('10.1.1-5.*') do |ip|
  #     ...
  #   end
  #
  #   IPAddr.each('::ff::02-0a::c3') do |ip|
  #     ...
  #   end
  #
  def IPAddr.each(cidr_or_glob,&block)
    unless (cidr_or_glob.include?('*') || cidr_or_glob.include?('-'))
      IPAddr.new(cidr_or_glob).each(&block)
      return nil
    end

    if cidr_or_glob.include?('::')
      prefix = if cidr_or_glob =~ /^::/
                 '::'
               else
                 ''
               end

      separator = '::'
      base = 16

      format = lambda { |address|
        prefix + address.map { |i| '%.2x' % i }.join('::')
      }
    else
      separator = '.'
      base = 10

      format = lambda { |address| address.join('.') }
    end

    ranges = cidr_or_glob.split(separator).map { |segment|
      if segment == '*'
        (1..254)
      elsif segment.include?('-')
        start, stop = segment.split('-',2).map { |i| i.to_i(base) }

        (start..stop)
      elsif !(segment.empty?)
        segment.to_i(base)
      end
    }.compact

    expand_range = lambda { |address,remaining|
      if remaining.empty?
        block.call(format.call(address))
      else
        n = remaining.first
        remaining = remaining[1..-1]

        if n.kind_of?(Range)
          n.each { |i| expand_range.call(address + [i], remaining) }
        else
          expand_range.call(address + [n], remaining)
        end
      end
    }

    expand_range.call([], ranges)
    return nil
  end

  #
  # Iterates over each IP address that is included in the addresses mask,
  # passing each address to the specified _block_.
  #
  #   IPAddr.new('10.1.1.1/24').each do |ip|
  #     puts ip
  #   end
  #
  def each(&block)
    case @family
    when Socket::AF_INET
      family_mask = IN4MASK
    when Socket::AF_INET6
      family_mask = IN6MASK
    end

    (0..((~@mask_addr) & family_mask)).each do |i|
      block.call(_to_string(@addr | i))
    end

    return self
  end

end
