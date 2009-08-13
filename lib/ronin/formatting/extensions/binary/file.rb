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

require 'ronin/formatting/extensions/binary/string'

class File

  #
  # Converts the hexdump at the specified _path_ back into the original
  # raw-data using the given _options_.
  #
  # _options_ may contain the following keys:
  # <tt>:format</tt>:: The expected format of the hexdump. Must be either
  #                    <tt>:od</tt> or <tt>:hexdump</tt>.
  # <tt>:encoding</tt>:: Denotes the encoding used for the bytes within the
  #                      hexdump. Must be one of the following:
  #                      <tt>:binary</tt>:: Binary encoded bytes.
  #                      <tt>:octal</tt>:: Octal encoding.
  #                      <tt>:octal_bytes</tt>:: Octal encoded bytes.
  #                      <tt>:octal_shorts</tt>:: Octal encoded shorts.
  #                      <tt>:octal_ints</tt>:: Octal encoded integers.
  #                      <tt>:octal_quads</tt>:: Octal encoded quads.
  #                      <tt>:decimal</tt>:: Unsigned decimal encoding.
  #                      <tt>:decimal_bytes</tt>:: Unsigned decimal bytes.
  #                      <tt>:decimal_shorts</tt>:: Unsigned decimal shorts.
  #                      <tt>:decimal_ints</tt>:: Unsigned decimal ints.
  #                      <tt>:decimal_quads</tt>:: Unsigned decimal quads.
  #                      <tt>:hex</tt>:: Hexadecimal encoding.
  #                      <tt>:hex_bytes</tt>:: Hexadecimal bytes.
  #                      <tt>:hex_shorts</tt>:: Hexadecimal shorts.
  #                      <tt>:hex_ints</tt>:: Hexadecimal ints.
  #                      <tt>:hex_quads</tt>:: Hexadecimal quads.
  # <tt>:segment</tt>:: The length in bytes of each segment in the hexdump.
  #                     Defaults to 16, if not specified.
  #
  def File.unhexdump(path,options={})
    File.read(path).unhexdump(options)
  end

end
