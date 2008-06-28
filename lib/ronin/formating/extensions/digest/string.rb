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

require 'digest/md5'
require 'digest/sha1'
require 'digest/sha2'

class String

  #
  # Returns the MD5 checksum of the String.
  #
  def md5
    Digest::MD5.hexdigest(self)
  end

  #
  # Returns the SHA1 checksum of the String.
  #
  def sha1
    Digest::SHA1.hexdigest(self)
  end

  #
  # Returns the SHA2 checksum of the String.
  #
  def sha2
    Digest::SHA2.hexdigest(self)
  end

  #
  # Returns the SHA256 checksum of the String.
  #
  def sha256
    Digest::SHA256.hexdigest(self)
  end

  #
  # Returns the SHA512 checksum of the String.
  #
  def sha512
    Digest::SHA512.hexdigest(self)
  end

end
