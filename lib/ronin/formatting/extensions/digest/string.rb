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

require 'digest/md5'
require 'digest/sha1'
require 'digest/sha2'

class String

  #
  # @return [String] The MD5 checksum of the String.
  #
  # @example
  #   "hello".md5
  #   # => "5d41402abc4b2a76b9719d911017c592"
  #
  def md5
    Digest::MD5.hexdigest(self)
  end

  #
  # @return [String] The SHA1 checksum of the String.
  #
  # @example
  #   "hello".sha1
  #   # => "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"
  #
  def sha1
    Digest::SHA1.hexdigest(self)
  end

  #
  # @return [String] The SHA2 checksum of the String.
  #
  # @example
  #   "hello".sha2
  #   # => "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
  #
  def sha2
    Digest::SHA2.hexdigest(self)
  end

  #
  # @return [String] The SHA256 checksum of the String.
  #
  # @example
  #   "hello".sha256
  #   # => "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
  #
  def sha256
    Digest::SHA256.hexdigest(self)
  end

  #
  # @return [String] The SHA512 checksum of the String.
  #
  # @example
  #   "hello".sha512
  #   # => "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"
  #
  def sha512
    Digest::SHA512.hexdigest(self)
  end

end
