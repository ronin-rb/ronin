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

class String

  #
  # Converts the +String+ into an appropriate method name.
  #
  #   'GPL 2'.to_method_name # => "gpl_2"
  #
  #   'Ronin::Arch' # => "ronin_arch"
  #
  def to_method_name
    downcase.gsub(/(::|[\s\-])/,'_')
  end

  #
  # Returns the common prefix of the string and the specified _other_
  # string. If no common prefix can be found an empty string will be
  # returned.
  #
  def common_prefix(other)
    min_length = [length, other.length].min

    min_length.times do |i|
      if self[i] != other[i]
        return self[0...i]
      end
    end

    return self[0...min_length]
  end

  #
  # Returns the common postfix of the string and the specified _other_
  # string. If no common postfix can be found an empty string will be
  # returned.
  #
  def common_postfix(other)
    min_length = [length, other.length].min

    (min_length - 1).times do |i|
      index = (length - i -1)
      other_index = (other.length - i -1)

      if self[index] != other[other_index]
        return self[(index + 1)..-1]
      end
    end

    return ''
  end

  #
  # Returns the uncommon substring within the specified _other_ string,
  # which does not occur within the string. If no uncommon substring can be
  # found, an empty string will be returned.
  #
  def uncommon_substring(other)
    prefix = common_prefix(other)
    postfix = self[prefix.length..-1].common_postfix(other[prefix.length..-1])

    return self[prefix.length...(length - postfix.length)]
  end

  #
  # Saves the string to the specified _path_.
  #
  def save(path)
    File.open(path,'w') do |file|
      file.write(path)
    end
  end

  #
  # Inspects the string, returning a C style encoded version of the string.
  #
  #   "hello\x00\073\x90\r\n"
  #   # => "hello\0;\x90\r\n"
  #
  def inspect
    c_string = ''

    each_byte do |b|
      c_string << case b
                  when 0x00
                    "\\0"
                  when 0x07
                    "\\a"
                  when 0x08
                    "\\b"
                  when 0x09
                    "\\t"
                  when 0x0a
                    "\\n"
                  when 0x0b
                    "\\v"
                  when 0x0c
                    "\\f"
                  when 0x0d
                    "\\r"
                  when 0x22
                    "\\\""
                  when 0x5c
                    "\\\\"
                  when (0x20..0x7e)
                    b.chr
                  else
                    ("\\x%.2x" % b)
                  end
    end

    return "\"#{c_string}\""
  end

end
